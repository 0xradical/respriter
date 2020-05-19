Feature: Custom Headers
  Given a HTTP header with JSON LD
  When receiving it
  Then JSON LD is properly parsed

  Scenario: when received content with JSON LD
    Given a Pipes::Fetcher without options
    And   a Pipeline
    And   a PipeProcess with attributes
    """
    { "accumulator": { "url": "http://json_ld.course.com/" } }
    """
    And a get route that responds to http://json_ld.course.com/
    And returning an HTTP response with
    """
    {
      "body": %{
        <html>
        <script type="application/ld+json">
        {
          "@id":         "http://json_ld.course.com/",
          "@type":       "Course",
          "name":        "Learning JSON LD",
          "description": "About JSON LD"
        }
        </script>
        </html>
      }
    }
    """
    When pipe_process is executed
    Then pipe_process accumulator/json_ld/0/@id become "http://json_ld.course.com/"
    And  pipe_process accumulator/json_ld/0/@type become "Course"
    And  pipe_process accumulator/json_ld/0/name become "Learning JSON LD"
    And  pipe_process accumulator/json_ld/0/description become "About JSON LD"

