Feature: Content Type Handler
  Given an Content Type HTTP header
  When receiving an HTTP response
  Then content is properly parsed

  Scenario: when received "application/json" as Content Type
    Given a Pipes::Fetcher without options
    And a Pipeline
    And a PipeProcess with attributes
    """
    { "accumulator": { "url": "https://json.page/" } }
    """
    And a get route that responds to https://json.page/
    And returning an HTTP response with
    """
    {
      "headers": { "Content-Type": "application/json"},
      "body":    '{"abc":"def"}'
    }
    """
    When pipe_process is executed
    Then pipe_process accumulator/payload become { abc: 'def' }

  Scenario: when received "application/x-gzip" as Content Type
    Given a Pipes::Fetcher without options
    And a Pipeline
    And a PipeProcess with attributes
    """
    { "accumulator": { "url": "https://gzipped.page/" } }
    """
    And a get route that responds to https://gzipped.page/
    And returning an HTTP response with
    """
    {
      "headers": { "Content-Type": "application/x-gzip"},
      "body":    "\u001F\x8B\b\u0000\xC0\xAF\u0017\\\u0000\u0003\u001D\x8C;\u000E\x830\u0010\u0005\xAF\xF2\xE8\xA3܃\"UN\xB0\xC1V\xF2$\x9B\x85\xFDPp\xFA\u0018\x9A\xD1\u0014\xA3y\xA5{v\xCC\xDB\xE0\u0003\v\x97V\u001C\a\v\u001D\x8Da\n\xF9T\v\xFA\u0013o\"\xD1s-\xE9\b\u0019\xC6Plbr\xB5\xA1]0>\xBD\xFE\xB0g\x85ޥ\xE2\u0010\xE2K\u0013;\xE9\xD3\u001F\xAB(\x99\u001Cl\u0000\u0000\u0000"
    }
    """
    When pipe_process is executed
    Then pipe_process accumulator/payload become 'Mussum Ipsum, ciclds vidis litro abertis. Si u mundus ta muito paradis toma um meh que o mundo vai girarzis!'

  Scenario: when not received Content Type, but we know previously that content is gzipped
    Given a Pipes::Fetcher with options
    """
    { "gzip": true }
    """
    And a Pipeline
    And a PipeProcess with attributes
    """
    { "accumulator": { "url": "https://undescribed.gzipped.page/" } }
    """
    And a get route that responds to https://undescribed.gzipped.page/
    And returning an HTTP response with
    """
    {
      "body": "\u001F\x8B\b\u0000\xC0\xAF\u0017\\\u0000\u0003\u001D\x8C;\u000E\x830\u0010\u0005\xAF\xF2\xE8\xA3܃\"UN\xB0\xC1V\xF2$\x9B\x85\xFDPp\xFA\u0018\x9A\xD1\u0014\xA3y\xA5{v\xCC\xDB\xE0\u0003\v\x97V\u001C\a\v\u001D\x8Da\n\xF9T\v\xFA\u0013o\"\xD1s-\xE9\b\u0019\xC6Plbr\xB5\xA1]0>\xBD\xFE\xB0g\x85ޥ\xE2\u0010\xE2K\u0013;\xE9\xD3\u001F\xAB(\x99\u001Cl\u0000\u0000\u0000"
    }
    """
    When pipe_process is executed
    Then pipe_process accumulator/payload become 'Mussum Ipsum, ciclds vidis litro abertis. Si u mundus ta muito paradis toma um meh que o mundo vai girarzis!'
