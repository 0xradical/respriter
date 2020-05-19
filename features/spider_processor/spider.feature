Feature: Spider Crawling
  Given fetched page
  Then should be able extract urls
  And recursivelly crawl entire site

  Scenario: fetching a simple page
    Given a Dataset named as should_be_unique
    And a Pipes::Spider without options
    And a Pipeline
    And a PipeProcess with attributes
    """
    {
      "accumulator": {
        "payload": "<a href='lorem.html'>Lorem</a>",
        "status_code": 200,
        "url": "http://some.page.com/pqp.html"
      }
    }
    """
    When observing pipe execution
    And  PipeProcess.count have changed
    Then pipe_process status become :pending
    And  there is a PipeProcess with { initial_accumulator: { url: 'http://some.page.com/lorem.html' } }

  Scenario: fetching a simple page with other domain link
    Given a Dataset named as should_be_unique
    And a Pipes::Spider without options
    And a Pipeline
    And a PipeProcess with attributes
    """
    {
      "accumulator": {
        "payload": "<a href='http://other.domain.com/lorem.html'>Lorem</a>",
        "status_code": 200,
        "url": "http://some.page.com/pqp.html"
      }
    }
    """
    When observing pipe execution
    And  PipeProcess.count have not changed
    Then pipe_process status become :pending

  Scenario: fetching an already fetched page
    Given a Dataset named as should_be_unique
    And a Pipes::Spider without options
    And a Pipeline
    And a PipeProcess with attributes
    """
    {
      "initial_accumulator": {
        "url": "http://some.page.com/fetched.html"
      },
      "accumulator": {
        "payload": "<a href='fetched.html'>Lorem</a>",
        "status_code": 200,
        "url": "http://some.page.com/fetched.html"
      }
    }
    """
    When observing pipe execution
    And  PipeProcess.count have not changed
    Then pipe_process status become :pending

  Scenario: fetching an path with #
    Given a Dataset named as should_be_unique
    And a Pipes::Spider without options
    And a Pipeline
    And a PipeProcess with attributes
    """
    {
      "initial_accumulator": {
        "url": "http://some.page.com/fetched.html"
      },
      "accumulator": {
        "payload": "<a href='fetched.html#lorem'>Lorem</a>",
        "status_code": 200,
        "url": "http://some.page.com/fetched.html"
      }
    }
    """
    When observing pipe execution
    And  PipeProcess.count have not changed
    Then pipe_process status become :pending

  Scenario: fetching an path with //
    Given a Dataset named as should_be_unique
    And a Pipes::Spider with options
    """
    { "host_whitelist": ["ipsum.com"] }
    """
    And a Pipeline
    And a PipeProcess with attributes
    """
    {
      "initial_accumulator": {
        "url": "https://some.page.com/fetched.html"
      },
      "accumulator": {
        "payload": "<a href='//ipsum.com/lorem.html'>Lorem</a>",
        "status_code": 200,
        "url": "https://some.page.com/fetched.html"
      }
    }
    """
    When observing pipe execution
    And  PipeProcess.count have changed
    Then pipe_process status become :pending
    And  there is a PipeProcess with { initial_accumulator: { url: 'https://ipsum.com/lorem.html' } }
