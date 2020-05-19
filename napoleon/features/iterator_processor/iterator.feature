Feature: Iterator Processor
  Given Iterator Processor
  Then it should do nothing, only changes status

  Scenario: without receiving accumulator
    Given a Pipes::Iterator without options
    And a Pipeline
    And a PipeProcess
    When observing pipe execution
    And  PipeProcess.count have not changed
    Then pipe_process status become :pending

  Scenario: receiving empty accumulator
    Given a Pipes::Iterator without options
    And a Pipeline
    And a PipeProcess with attributes
    """
    { "accumulator": {} }
    """
    When observing pipe execution
    And  PipeProcess.count have not changed
    Then pipe_process status become :pending

  Scenario: changing status by options
    Given a Pipes::Iterator with options
    """
    { "status": "skipped" }
    """
    And a Pipeline
    And a PipeProcess with attributes
    """
    {
      "accumulator": {
        "whatever": "attribute"
      }
    }
    """
    When observing pipe execution
    And  PipeProcess.count have changed
    Then pipe_process status become :pending
    And  there is a PipeProcess with { initial_accumulator: { whatever: 'attribute' }, pipeline_id: @pipeline.id }
