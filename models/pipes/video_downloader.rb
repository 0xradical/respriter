module Pipes
  class VideoDownloader < Pipe
    def execute(pipe_process, accumulator)
      params = options.merge accumulator.deep_symbolize_keys

      key = [ params[:folder], params[:path] ].compact.join '/'

      downloader_options = params.slice :accepted_statuses, :http_headers
      begin
        Napoleon::VideoDownloader.new(params[:video_url], bucket, key, downloader_options).call
      rescue
        pipe_process.retry! $!
      end

      [
        params[:status].to_sym,
        { video_url: "#{host}#{key}" }
      ]
    end

    protected
    def default_options
      {
        status: :pending,
        accepted_statuses: [ [ 200, 299 ] ]
      }
    end

    def host
      if NapoleonApp.test?
        'http://s3.clspt/video-bucket/'
      else
        # TODO: Handle ENV['VIDEO_HOST'] for test environment
        ENV['VIDEO_HOST']
      end
    end

    def bucket
      # TODO: Handle ENV['VIDEO_BUCKET'] for test environment
      ENV['VIDEO_BUCKET']
    end
  end
end
