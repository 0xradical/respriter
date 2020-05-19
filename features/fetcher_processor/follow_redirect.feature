Feature: Follow Redirect Handler
  Given a request with follow_redirect option
  When receiving an HTTP response
  I should be able to follow redirects or not according to that option

  Scenario: when follow_redirect is set to true and a not redirected page is returned
    Given a Pipes::Fetcher with options
    """
    {
      "http": { "follow_redirects": true }
    }
    """
    And a Pipeline
    And a PipeProcess with attributes
    """
    { "accumulator": { "url": "https://succeeded.page/" } }
    """
    And a get route that responds to https://succeeded.page/
    And returning an HTTP response with
    """
    {
      "status": 200,
      "body":  "Succeeded Page"
    }
    """
    When pipe is executed
    Then pipe_process status become :pending

  Scenario: when follow_redirect is set to false and a not redirected page is returned
    Given a Pipes::Fetcher with options
    """
    {
      "http": { "follow_redirects": false }
    }
    """
    And a Pipeline
    And a PipeProcess with attributes
    """
    { "accumulator": { "url": "https://succeeded.page/" } }
    """
    And a get route that responds to https://succeeded.page/
    And returning an HTTP response with
    """
    {
      "status": 200,
      "body":  "Succeeded Page"
    }
    """
    When pipe is executed
    Then pipe_process status become :pending

  Scenario: when follow_redirect is set to true and a redirected page is returned
    Given a Pipes::Fetcher with options
    """
    {
      "http": { "follow_redirects": true },
      "cache": { "refresh": true }
    }
    """
    And a Pipeline
    And a PipeProcess with attributes
    """
    { "accumulator": { "url": "https://redirected.page/" } }
    """
    And a get route that responds to https://redirected.page/
    And returning an HTTP response with
    """
    {
      "status":  303,
      "headers": { "location": "https://succeeded.page/" }
    }
    """
    And a get route that responds to https://succeeded.page/
    And returning an HTTP response with
    """
    {
      "status": 200,
      "body":  "Succeeded Page"
    }
    """
    When pipe is executed
    Then pipe_process status become :pending

  Scenario: when follow_redirect is set to false and a redirected page is returned
    Given a Pipes::Fetcher with options
    """
    {
      "http": { "follow_redirects": false },
      "status_map": [
        [ 303, "failed" ]
      ],
      "cache": { "refresh": true }
    }
    """
    And a Pipeline
    And a PipeProcess with attributes
    """
    { "accumulator": { "url": "https://redirected.page/" } }
    """
    And a get route that responds to https://redirected.page/
    And returning an HTTP response with
    """
    {
      "status":  303,
      "headers": { "location": "https://succeeded.page/" }
    }
    """
    When pipe is executed
    Then pipe_process status become :failed

  Scenario: when follow_redirect is set to true and there are multiple redirects
    Given a Pipes::Fetcher with options
    """
    {
      "http": { "follow_redirects": { "limit": 10 } },
      "cache": { "refresh": true }
    }
    """
    And a Pipeline
    And a PipeProcess with attributes
    """
    { "accumulator": { "url": "https://redirected.page/" } }
    """
    And a get route that responds to https://redirected.page/
    And redirects to https://succeeded.page/ after 9 leaps with
    """
    {
      "status":  200,
      "body":  "Succeeded Page"
    }
    """
    When pipe is executed
    Then pipe_process status become :pending
    And  pipe_process accumulator/redirected become true
    And  pipe_process accumulator/redirect_count become 9
    And  pipe_process accumulator/original_url become 'https://redirected.page/'
    And  pipe_process accumulator/current_url become 'https://succeeded.page/'

