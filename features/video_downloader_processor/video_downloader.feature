Feature: Video Downloader Processing
  Given a video URL
  I should be able download it
  Then it will be stored and available

  @ignore-webmock
  Scenario: a video downloader against a page with Content-Type
    Given a Pipes::VideoDownloader without options
    And a Pipeline
    And a random pattern repeated 1000 times
    And a PipeProcess with attributes
    """
    {
      accumulator: {
        video_url: "http://heavyload.service.test:9999/big_file/#{ @random_pattern }/1000.mp4",
        folder:    'some_video',
        path:      'is_here.mp4'
      }
    }
    """
    When pipe_process is executed
    Then signed http://s3.clspt/video-bucket/some_video/is_here.mp4 contains same random pattern repeated many times

  @ignore-webmock
  Scenario: a video downloader against a page without Content-Type
    Given a Pipes::VideoDownloader without options
    And a Pipeline
    And a random pattern repeated 1000 times
    And a PipeProcess with attributes
    """
    {
      accumulator: {
        video_url: "http://heavyload.service.test:9999/stream_big_file/#{ @random_pattern }/1000.mp4",
        folder:    'some_video',
        path:      'is_there.mp4'
      }
    }
    """
    When pipe_process is executed
    Then signed http://s3.clspt/video-bucket/some_video/is_there.mp4 contains same random pattern repeated many times

  @ignore-webmock
  Scenario: a video downloader against a page without Content-Type
    Given a Pipes::VideoDownloader with options
    """
    {
      "folder": "these_is_some_video",
      "path":   "out_there.avi"
    }
    """
    And a Pipeline
    And a random pattern repeated 100000 times
    And a PipeProcess with attributes
    """
    {
      accumulator: { video_url: "http://heavyload.service.test:9999/big_file/#{ @random_pattern }/100000.mp4" }
    }
    """
    When pipe_process is executed
    Then signed http://s3.clspt/video-bucket/these_is_some_video/out_there.avi contains same random pattern repeated many times

  @ignore-webmock
  Scenario: a video downloader that responds an error
    Given a Pipes::VideoDownloader with options
    """
    {
      "folder": "these_is_some_video",
      "path":   "out_there.avi"
    }
    """
    And a Pipeline
    And a random pattern repeated 100000 times
    And a PipeProcess with attributes
    """
    {
      accumulator: { video_url: "http://heavyload.service.test:9999/not_found.mp4" }
    }
    """
    When pipe_process is executed
    Then pipe_process should be retried
