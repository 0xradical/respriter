Feature: Cached Requests
  Given a page that was once requested
  When requesting again
  Then it should not be equests again, unless explicitly desired

  Scenario: requesting a brand new page and then requesting it again
    Given a Pipes::Fetcher without options
    And   a Pipeline
    And   a PipeProcess with attributes
    """
    { "accumulator": { "url": "http://cached.com/", "cache": { "version": "abc" } } }
    """
    And a get route that responds to http://cached.com/
    And returning an HTTP response with
    """
    { body: 'will be cached' }
    """
    When pipe_process is executed
    Then pipe_process accumulator/payload become "will be cached"
    And  page http://cached.com/ was requested

  Scenario: requesting a same page again
    Given a Pipes::Fetcher without options
    And   a Pipeline
    And   a PipeProcess with attributes
    """
    { "accumulator": { "url": "http://cached.com/", "cache": { "version": "abc" } } }
    """
    And a get route that responds to http://cached.com/
    And returning an HTTP response with
    """
    { body: 'will be cached' }
    """
    When pipe_process is executed
    Then pipe_process accumulator/payload become "will be cached"
    And  page http://cached.com/ was not requested

  Scenario: forcing request and ignore caching
    Given a Pipes::Fetcher with options
    """
    { "cache": { "refresh": true } }
    """
    And   a Pipeline
    And   a PipeProcess with attributes
    """
    { "accumulator": { "url": "http://cached.com/", "cache": { "version": "abc" } } }
    """
    And a get route that responds to http://cached.com/
    And returning an HTTP response with
    """
    { body: 'will be back' }
    """
    When pipe_process is executed
    Then pipe_process accumulator/payload become "will be back"
    And  page http://cached.com/ was requested
