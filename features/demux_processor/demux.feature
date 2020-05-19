Feature: Demux Processing
  Given an array of data
  I should be able to delegate each datum
  Then each datum will be part of a new pipe_process

  Scenario: a demux without options
    Given a Pipes::Demux without options
    And a Pipeline
    And @another_pipeline Pipeline with attributes
    """
    { data: { next_pipeline_id: @pipeline.id } }
    """
    And a PipeProcess with attributes
    """
    {
      pipeline_id: @another_pipeline.id,
      accumulator: [
        { accumulator: { data: '1st Data' } },
        { accumulator: { data: '2nd Data' } },
        { accumulator: { data: '3rd Data' } }
      ]
    }
    """
    When pipe is executed
    Then pipe_process status become :pending
    And pipe_process accumulator has those keys: new_pipe_process_count
    And pipe_process accumulator/new_pipe_process_count become 3
    And pipeline has 3 pipe_processes
    And pipeline has a pipe_process with { status: :pending, accumulator: { data: '1st Data' } }
    And pipeline has a pipe_process with { status: :pending, accumulator: { data: '2nd Data' } }
    And pipeline has a pipe_process with { status: :pending, accumulator: { data: '3rd Data' } }

  Scenario: a demux editing status
    Given a Pipes::Demux with options
    """
    { "status": "skipped" }
    """
    And a Pipeline
    And @another_pipeline Pipeline with attributes
    """
    { data: { next_pipeline_id: @pipeline.id } }
    """
    And a PipeProcess with attributes
    """
    {
      pipeline_id: @another_pipeline.id,
      accumulator: [
        { accumulator: { data: '1st Data' } },
        { accumulator: { data: '2nd Data' } },
        { accumulator: { data: '3rd Data' } }
      ]
    }
    """
    When pipe is executed
    Then pipe_process status become :skipped
    And pipe_process accumulator has those keys: new_pipe_process_count
    And pipe_process accumulator/new_pipe_process_count become 3
    And pipeline has 3 pipe_processes
    And pipeline has a pipe_process with { status: :pending, accumulator: { data: '1st Data' } }
    And pipeline has a pipe_process with { status: :pending, accumulator: { data: '2nd Data' } }
    And pipeline has a pipe_process with { status: :pending, accumulator: { data: '3rd Data' } }

  Scenario: a demux that create waiting entries
    Given a Pipes::Demux with options
    """
    { "entry": { "status": "skipped" } }
    """
    And a Pipeline
    And @another_pipeline Pipeline with attributes
    """
    { data: { next_pipeline_id: @pipeline.id } }
    """
    And a PipeProcess with attributes
    """
    {
      pipeline_id: @another_pipeline.id,
      accumulator: [
        { accumulator: { data: '1st Data' } },
        { accumulator: { data: '2nd Data' } },
        { accumulator: { data: '3rd Data' } }
      ]
    }
    """
    When pipe is executed
    Then pipe_process status become :pending
    And pipe_process accumulator has those keys: new_pipe_process_count
    And pipe_process accumulator/new_pipe_process_count become 3
    And pipeline has 3 pipe_processes
    And pipeline has a pipe_process with { status: :skipped, accumulator: { data: '1st Data' } }
    And pipeline has a pipe_process with { status: :skipped, accumulator: { data: '2nd Data' } }
    And pipeline has a pipe_process with { status: :skipped, accumulator: { data: '3rd Data' } }

  Scenario: a demux with explicit pipeline_id as option
    Given a Pipeline
    And a Pipes::Demux with options
    """
    { entry: { pipeline_id: @pipeline.id } }
    """
    And @another_pipeline Pipeline
    And a PipeProcess with attributes
    """
    {
      pipeline_id: @another_pipeline.id,
      accumulator: [
        { accumulator: { data: '1st Data' } },
        { accumulator: { data: '2nd Data' } },
        { accumulator: { data: '3rd Data' } }
      ]
    }
    """
    When pipe is executed
    Then pipe_process status become :pending
    And pipe_process accumulator has those keys: new_pipe_process_count
    And pipe_process accumulator/new_pipe_process_count become 3
    And pipeline has 3 pipe_processes
    And pipeline has a pipe_process with { status: :pending, accumulator: { data: '1st Data' } }
    And pipeline has a pipe_process with { status: :pending, accumulator: { data: '2nd Data' } }
    And pipeline has a pipe_process with { status: :pending, accumulator: { data: '3rd Data' } }
