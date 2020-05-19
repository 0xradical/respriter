Feature: Proxied Requests
  Given a page that requires to be proxyed
  When requested
  Then it should be proxied

  Scenario: requesting a brand new page
    Given a Pipes::Fetcher with options
    """
    {
      "cache": { "refresh": true },
      "http": {
        "proxy": {
          "uri":      "http://proxy.test:8888",
          "user":     "some_user",
          "password": "some_pass"
        }
      }
    }
    """
    And a Pipeline
    And a PipeProcess with attributes
    """
    { "accumulator": { "url": "http://heavyload.service.test:9999/hello" } }
    """
    When pipe_process is executed
    Then pipe_process accumulator/response_headers/via become "1.1 dumb_simple_proxy"
    And  pipe_process accumulator/payload become 'Hello world!'
