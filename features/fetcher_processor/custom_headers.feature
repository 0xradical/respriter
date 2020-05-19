Feature: Custom HTTP Headers
  Given a HTTP request with headers
  Then those should be sent

  Scenario: sending HTTP from options
    Given a Pipes::Fetcher with options
    """
    {
      "http": {
        "headers": {
          "X-CUSTOM-HEADER": "from options"
        }
      }
    }
    """
    And   a Pipeline
    And   a PipeProcess with attributes
    """
    { "accumulator": { "url": "http://header.from.options.com/" } }
    """
    And a get route that responds to http://header.from.options.com/
    And returning an HTTP response with
    """
    { "body": 'Header from Options' }
    """
    When pipe_process is executed
    Then pipe_process accumulator/request_headers/X-custom-header become "from options"

  Scenario: sending HTTP from accumulator
    Given a Pipes::Fetcher without options
    And   a Pipeline
    And   a PipeProcess with attributes
    """
    {
      "accumulator": {
        "url": "http://header.from.accumulator.com/",
        "http": {
          "headers": {
            "X-CUSTOM-HEADER": "from accumulator"
          }
        }
      }
    }
    """
    And a get route that responds to http://header.from.accumulator.com/
    And returning an HTTP response with
    """
    { "body": 'Header from Accumulator' }
    """
    When pipe_process is executed
    Then pipe_process accumulator/request_headers/X-custom-header become "from accumulator"

