Feature: Default Fetching Simple Pages
  Given a URL and a Fetcher Pipe
  I should be able to request it
  Then pipe_process got status and accumulator updated

  Scenario: a simple uncached page
    Given a Pipes::Fetcher without options
    And a Pipeline
    And a PipeProcess with attributes
    """
    { "accumulator": { "url": "https://simple.page/" } }
    """
    And a get route that responds to https://simple.page/
    And returning an HTTP response with
    """
    {
      "status": 201,
      "headers": {"X-CUSTOM-HEADER": "xpto value"},
      "body":  "Simple Page"
    }
    """
    When pipe_process is executed
    Then pipe_process status become :succeeded
    And pipe_process accumulator has those keys: cookie_jar payload json_ld status_code request_headers response_headers current_url original_url redirect_count redirected redirected_urls method url params
    And pipe_process accumulator/request_headers/If-Modified-Since should not be present
    And pipe_process accumulator/request_headers/User-Agent become 'Googlebot/2.1 (+http://www.google.com/bot.html)'
    And pipe_process accumulator/response_headers/x-custom-header become 'xpto value'
    And pipe_process accumulator/status_code become 201
    And pipe_process accumulator/payload become 'Simple Page'

  Scenario: a simple cached page that returns an 304 due to If-Modified-Since
    Given a Pipes::Fetcher with options
    """
    {"cache": {"refresh": true}}
    """
    And a Pipeline
    And a PipeProcess with attributes
    """
    { "accumulator": { "url": "https://simple.page/" } }
    """
    And a get route that responds to https://simple.page/
    And returning an HTTP response with
    """
    { "status": 304 }
    """
    When pipe_process is executed
    Then pipe_process status become :succeeded
    And pipe_process accumulator has those keys: cookie_jar payload json_ld status_code request_headers response_headers current_url original_url redirect_count redirected redirected_urls method url params
    And pipe_process accumulator/request_headers/If-Modified-Since should be present
    And pipe_process accumulator/request_headers/User-Agent become 'Googlebot/2.1 (+http://www.google.com/bot.html)'
    And pipe_process accumulator/response_headers/x-custom-header become 'xpto value'
    And pipe_process accumulator/status_code become 201
    And pipe_process accumulator/payload become 'Simple Page'

  Scenario: a simple cached page after updated page
    Given a Pipes::Fetcher with options
    """
    {"cache": {"refresh": true}}
    """
    And a Pipeline
    And a PipeProcess with attributes
    """
    { "accumulator": { "url": "https://simple.page/" } }
    """
    And a get route that responds to https://simple.page/
    And returning an HTTP response with
    """
    {
      "status": 200,
      "headers": {"X-CUSTOM-HEADER": "mussum ipsum"},
      "body":  "Updated Page"
    }
    """
    When pipe_process is executed
    Then pipe_process status become :succeeded
    And pipe_process accumulator has those keys: cookie_jar payload json_ld status_code request_headers response_headers current_url original_url redirect_count redirected redirected_urls method url params
    And pipe_process accumulator/request_headers/If-Modified-Since should be present
    And pipe_process accumulator/request_headers/User-Agent become 'Googlebot/2.1 (+http://www.google.com/bot.html)'
    And pipe_process accumulator/response_headers/x-custom-header become 'mussum ipsum'
    And pipe_process accumulator/status_code become 200
    And pipe_process accumulator/payload become 'Updated Page'
