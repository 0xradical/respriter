# frozen_string_literal: true

def file_versions(public_output_path, file, globbed_suffix: false, exact_version: false)
  file_prefix, file_digest, file_ext = file.scan(/(.*)([0-9a-f]{20})(.*)/).first
  file_digest_pattern = '[0-9a-f]{20}'
  if !file_prefix || !file_digest
    file_prefix, file_digest, file_ext = file.scan(/(.*)([0-9a-f]{8})(.*)/).first
    file_digest_pattern = '[0-9a-f]{8}'
  end

  if file_prefix && file_ext
    Dir.glob(public_output_path.join("#{file_prefix}*")).grep(/#{public_output_path.join("#{file_prefix}#{exact_version ? file_digest : file_digest_pattern}#{file_ext}#{globbed_suffix ? '.*' : ''}")}/)
  else
    []
  end
end

def current_file_versions(public_output_path, file, count_to_keep: 2)
  file_versions(public_output_path, file).map do |version_of_file|
    if version_of_file == public_output_path.join(file).to_s
      [version_of_file, Float::INFINITY]
    else
      [version_of_file, File.mtime(version_of_file).utc.to_i]
    end
  end.compact.sort_by(&:last).reverse.take(count_to_keep).map(&:first)
end

namespace :assets do
  desc 'Compile asset bundles using webpack for production with digests into $WEBPACK_PUBLIC_OUTPUT_PATH'
  task precompile: [:environment] do
    # NOOP
    # This is handled by npm run build
  end

  desc 'Assets clean'
  task clean: [:environment] do
    public_output_path = Rails.root.join('public', ENV['WEBPACK_PUBLIC_OUTPUT_PATH'])
    public_manifest_path = public_output_path.join('manifest.json')

    if public_output_path.exist? && public_manifest_path.exist?

      # everyone is marked to be cleanup upfront
      cleanup_plan = Dir.glob(public_output_path.join('**/*')).select { |f| File.file?(f) }.reduce({}) { |acc, file| acc.merge({ file => true }) }

      # then we whitelist...

      # manifest.json
      cleanup_plan["#{public_output_path}/manifest.json"] = false

      # current manifested files, except .map or LICENSE.txt
      manifest = JSON.load(File.read(public_manifest_path))
      files_in_manifest = manifest.except('entrypoints').values.map { |f| Rails.root.join('public', f.sub(%r{^/}, '')).to_s }
      current_manifest_files = files_in_manifest.flat_map do |file_in_manifest|
        current_file_versions(public_output_path, file_in_manifest, count_to_keep: 2)
      end.flat_map do |file|
        file_versions(public_output_path, file, globbed_suffix: true, exact_version: true)
      end.uniq.grep_v(/\.(LICENSE|map)(\.[a-zA-Z0-9]{1,})*\Z/)

      cleanup_plan = cleanup_plan.merge(
        current_manifest_files.reduce({}) { |acc, file| acc.merge({ file => false }) }
      )

      # all hypernova root files
      cleanup_plan = cleanup_plan.merge(
        Dir.glob(public_output_path.join('hypernova*')).grep_v(/\.(LICENSE|map)(\.[a-zA-Z0-9]{1,})*\Z/).reduce({}) { |acc, file| acc.merge({ file => false }) }
      )

      # hypernova folder files, keep the last one...
      hypernova_folder_files = Dir.glob(public_output_path.join('hypernova/*')).flat_map do |hypernova_folder_file|
        current_file_versions(public_output_path, hypernova_folder_file, count_to_keep: 1)
      end.flat_map do |file|
        file_versions(public_output_path, file, globbed_suffix: true, exact_version: true)
      end.uniq.grep_v(/\.(LICENSE|map)(\.[a-zA-Z0-9]{1,})*\Z/)

      cleanup_plan = cleanup_plan.merge(
        hypernova_folder_files.reduce({}) { |acc, file| acc.merge({ file => false }) }
      )

      cleanup_plan.select do |_file, clean|
        clean
      end.each do |f, _|
        print "Deleting #{f} ... "
        begin
          File.delete(f)
          puts ' done.'
        rescue StandardError => e
          puts " failed (#{e.message})."
        end
      end

      # remove webpack cache
      FileUtils.rm_rf(Rails.root.join.join('node_modules/.cache/babel-loader'))
      FileUtils.rm_rf(Rails.root.join.join('node_modules/.cache/terser-webpack-plugin'))
    end
  end
end
