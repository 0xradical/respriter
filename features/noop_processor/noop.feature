Feature: Noop Processor
  Given Noop Processor
  Then it should do nothing, only changes status

  Scenario: with default options
    Given a Pipes::Noop without options
    And a Pipeline
    And a PipeProcess with attributes
    """
    {
      "accumulator": {
        "whatever": "attribute"
      }
    }
    """
    When pipe_process is executed
    Then pipe_process status become :waiting
    And pipe_process accumulator become { whatever: 'attribute' }

  Scenario: changing status by options
    Given a Pipes::Noop with options
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
    When pipe_process is executed
    Then pipe_process status become :skipped
    And pipe_process accumulator become { whatever: 'attribute' }
