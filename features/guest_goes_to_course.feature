@guest @guest-goes-to-course @javascript
Feature: Guest goes to course

  As a guest
  I want to click on the go to course button
  So I can enroll myself in the course

  Background:
    Given that courses are indexed

  @guest-goes-to-course @gtm
  Scenario: Guest goes to a course
    Given I'm on a search result page
    And an event is being tracked by GTM
    When I click on the course button
    Then I'm forwarded to the course provider
