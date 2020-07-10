# frozen_string_literal: true

namespace :assets do
  desc 'Compile asset bundles using webpack for production with digests into $WEBPACK_PUBLIC_OUTPUT_PATH'
  task precompile: [:environment] do
    # NOOP
    # This is handled by npm run build
  end

  desc 'Assets clean'
  task clean: [:environment] do
    count_to_keep = 2
    public_output_path = Rails.root.join('public', ENV['WEBPACK_PUBLIC_OUTPUT_PATH'])
    public_manifest_path = public_output_path.join('manifest.json')

    if public_output_path.exist? && public_manifest_path.exist?
      manifest = JSON.load(File.read(public_manifest_path))

      files_in_manifest = manifest.except('entrypoints').values.map { |f| f.sub(%r{^/?#{ENV['WEBPACK_PUBLIC_OUTPUT_PATH']}/?}, '').to_s }

      files_to_be_removed = files_in_manifest.flat_map do |file_in_manifest|
        file_prefix, file_ext = file_in_manifest.scan(/(.*)[0-9a-f]{20}(.*)/).first
        file_digest_length = 20

        unless file_prefix
          file_prefix, file_ext = file_in_manifest.scan(/(.*)[0-9a-f]{8}(.*)/).first
          file_digest_length = 8
        end

        versions_of_file = Dir.glob(public_output_path.join("#{file_prefix}*#{file_ext}*")).grep(/#{file_prefix}[0-9a-f]{#{file_digest_length}}#{file_ext}/)
        versions_of_file.map do |version_of_file|
          next if version_of_file =~ /^#{file_in_manifest}/

          [version_of_file, File.mtime(version_of_file).utc.to_i]
        end.compact.sort_by(&:last).reverse.drop(count_to_keep).map(&:first)
      end

      files_to_be_removed.uniq.each do |f|
        print "Deleting #{f} ... "
        begin
          File.delete(f)
          puts ' done.'
        rescue StandardError => e
          puts " failed (#{e.message})."
        end
      end
    end
  end
end
