@guest @guest-goes-to-course @javascript @elasticsearch
Feature: Guest goes to course

  As a guest
  I want to click on the go to course button
  So I can enroll myself in the course

  @guest-goes-to-course @gtm-event
  Scenario: Guest goes to a course
    Given I'm on a search result page
    When I click on the course button
    Then I'm forwarded to the course provider
