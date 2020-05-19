Feature: Resource Creating
  Given params
  Then should be able to create or update it

  Scenario: creating a simple resource
    Given a Dataset named as should_be_unique
    And a Pipes::ResourceCreator with options
    """
    {
      "kind":      "course",
      "relations": {}
    }
    """
    And a Pipeline
    And a PipeProcess with attributes
    """
    {
      "accumulator": {
        "unique_id": "unique_id_here",
        "content": {
          "key": "value"
        }
      }
    }
    """
    When observing pipe execution
    And  Resource.count have changed
    Then pipe_process status become :pending
    And  there is a Resource with { unique_id: 'unique_id_here', kind: :course }
    And  @resource has content as { key: 'value' }

  Scenario: creating a simple resource already created
    Given a Dataset named as should_be_unique
    And a Pipes::ResourceCreator with options
    """
    {
      "kind":      "course",
      "relations": {}
    }
    """
    And a Pipeline
    And a PipeProcess with attributes
    """
    {
      "accumulator": {
        "unique_id": "unique_id_here",
        "content": {
          "key": "changed value"
        }
      }
    }
    """
    When observing pipe execution
    And  Resource.count have not changed
    Then pipe_process status become :pending
    And  there is a Resource with { unique_id: 'unique_id_here', kind: :course }
    And  @resource has content as { key: 'changed value' }

  Scenario: adding new values didn't erase old ones
    Given a Dataset named as should_be_unique
    And a Pipes::ResourceCreator with options
    """
    {
      "kind":      "course",
      "relations": {}
    }
    """
    And a Pipeline
    And a PipeProcess with attributes
    """
    {
      "accumulator": {
        "unique_id": "unique_id_here",
        "content": {
          "added_key": { "added": "value" }
        }
      }
    }
    """
    When observing pipe execution
    And  Resource.count have not changed
    Then pipe_process status become :pending
    And  there is a Resource with { unique_id: 'unique_id_here', kind: :course }
    And  @resource has content as { key: 'changed value', added_key: { added: 'value' } }

  Scenario: adding new values withsame prefix keys perfmorms deep merge
    Given a Dataset named as should_be_unique
    And a Pipes::ResourceCreator with options
    """
    {
      "kind":      "course",
      "relations": {}
    }
    """
    And a Pipeline
    And a PipeProcess with attributes
    """
    {
      "accumulator": {
        "unique_id": "unique_id_here",
        "content": {
          "added_key": { "one": "more" }
        }
      }
    }
    """
    When observing pipe execution
    And  Resource.count have not changed
    Then pipe_process status become :pending
    And  there is a Resource with { unique_id: 'unique_id_here', kind: :course }
    And  @resource has content as { key: 'changed value', added_key: { added: 'value', one: 'more' } }
