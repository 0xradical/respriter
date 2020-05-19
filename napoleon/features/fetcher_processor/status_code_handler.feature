Feature: Status Code Handler
  Given status code mapping
  When receiving an HTTP status code
  I should be able to properly handle PipeProcess status

  Scenario: when status code matches a succeeded integer specified matcher
    Given a Pipes::Fetcher with options
    """
    {
      "status_map": [
        [ 200,        "succeeded" ],
        [ [201, 204], "pending"   ]
      ]
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
    When pipe_process is executed
    Then pipe_process status become :succeeded

  Scenario: when status code matches a pending lower bound value in range matcher
    Given a Pipes::Fetcher with options
    """
    {
      "status_map": [
        [ 200,        "succeeded" ],
        [ [201, 204], "pending"   ]
      ]
    }
    """
    And a Pipeline
    And a PipeProcess with attributes
    """
    { "accumulator": { "url": "https://lower.pending.page/" } }
    """
    And a get route that responds to https://lower.pending.page/
    And returning an HTTP response with
    """
    {
      "status": 201,
      "body":  "Created Page"
    }
    """
    When pipe is executed
    Then pipe_process status become :pending

  Scenario: when status code matches a pending middle bound value in range matcher
    Given a Pipes::Fetcher with options
    """
    {
      "status_map": [
        [ 200,        "succeeded" ],
        [ [201, 204], "pending"   ]
      ]
    }
    """
    And a Pipeline
    And a PipeProcess with attributes
    """
    { "accumulator": { "url": "https://middle.pending.page/" } }
    """
    And a get route that responds to https://middle.pending.page/
    And returning an HTTP response with
    """
    {
      "status": 202,
      "body":  "Accepted Page"
    }
    """
    When pipe is executed
    Then pipe_process status become :pending

  Scenario: when status code matches a pending upper bound value in range matcher
    Given a Pipes::Fetcher with options
    """
    {
      "status_map": [
        [ 200,        "succeeded" ],
        [ [201, 204], "pending"   ]
      ]
    }
    """
    And a Pipeline
    And a PipeProcess with attributes
    """
    { "accumulator": { "url": "https://upper.pending.page/" } }
    """
    And a get route that responds to https://upper.pending.page/
    And returning an HTTP response with
    """
    {
      "status": 204,
      "body":  "No Content Page"
    }
    """
    When pipe is executed
    Then pipe_process status become :pending

  Scenario: when status code didn't matches anything and retries are disabled
    Given a Pipes::Fetcher with options
    """
    {
      "status_map": [
        [ 200,        "succeeded" ],
        [ [201, 204], "pending"   ]
      ],
      "retry": {
        "enabled": false
      }
    }
    """
    And a Pipeline
    And a PipeProcess with attributes
    """
    { "accumulator": { "url": "https://not.found.page/" } }
    """
    And a get route that responds to https://not.found.page/
    And returning an HTTP response with
    """
    {
      "status": 404,
      "body":  "Not Found"
    }
    """
    When pipe_process is executed
    Then pipe_process status become :failed

  Scenario: when status code didn't matches anything and retries are enabled
    Given a Pipes::Fetcher with options
    """
    {
      "status_map": [
        [ 200,        "succeeded" ],
        [ [201, 204], "pending"   ]
      ],
      "retry": {
        "enabled": true,
        "refresh": "always"
      }
    }
    """
    And a Pipeline
    And a PipeProcess with attributes
    """
    {
      "accumulator": { "url": "https://not.found.page/" },
      "initial_accumulator": { "url": "https://not.found.page/" }
    }
    """
    And a get route that responds to https://not.found.page/
    And returning an HTTP response with
    """
    {
      "status": 404,
      "body":  "Not Found"
    }
    """
    When pipe_process is executed
    And  pipe_process status become :pending
    When a get route that responds to https://not.found.page/
    And  returning an HTTP response with
    """
    {
      "status": 200,
      "body":  "Now it was Found"
    }
    """
    And  background processor executes PipeProcess::RetryJob job after 8 minutes
    And  pipe_process is reloaded
    Then pipe_process status become :succeeded
