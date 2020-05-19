module Napoleon
  class Storage < ActiveSupport::Cache::Store
    attr_reader :client, :bucket

    def initialize(options = nil)
      super options
      silence! if NapoleonApp.test?
      @bucket = options.fetch :bucket
      @client ||= Aws::S3::Client.new Napoleon.config.aws[:s3]
    end

    def exist?(name, **options)
      options = merged_options options

      instrument(:exist?, name) do
        return false unless exists_entry?(name, options[:etag])

        entry = read_entry(normalize_key(name, options), options)
        (entry && !entry.expired? && !entry.mismatched?(normalize_version(name, options))) || false
      end
    end

    def copy(from_name, to_name)
      @client.copy_object copy_source: "/#{@bucket}/#{from_name}", bucket: @bucket, key: to_name
    end

    def metadata(name)
      entry_header(name).metadata
    rescue Aws::S3::Errors::NotFound
      nil
    end

    def delete_all
      marker = nil
      loop do
        response = @client.list_objects bucket: @bucket, marker: marker
        marker = response[:next_marker]
        break if response[:contents].empty?
        response[:contents].each do |content|
          @client.delete_object bucket: @bucket, key: content[:key]
        end
      end
    end

    private
    def entry_header(name)
      @client.head_object bucket: @bucket, key: name
    end

    def exists_entry?(name, etag)
      header = entry_header
      return etag == header.metadata['etag'] if etag.present?
      true
    rescue Aws::S3::Errors::NotFound
      false
    end

    def read_entry(key, options)
      dump = @client.get_object(bucket: @bucket, key: key).body.read
      Marshal.load Zlib.inflate(dump)
    rescue Aws::S3::Errors::NoSuchKey
      nil
    end

    def write_entry(key, entry, options)
      payload = Zlib.deflate Marshal.dump(entry)
      @client.put_object bucket: @bucket, key: key, body: StringIO.new(payload), metadata: options[:metadata]
      true
    end

    def delete_entry(key, options)
      @client.delete_object bucket: @bucket, key: key
      true
    end
  end
end
