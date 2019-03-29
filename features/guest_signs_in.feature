@guest @guest-signs-in @javascript
Feature: Guest signs in

  As a guest
  With a registered user account
  I want to sign in at Classpert
  So I can access logged content

  @guest-signs-in-1
  Scenario: Guest successfull sign in with email
    Given I visit the sign in page
    When I fill my email "john.doe@quero.com" and my password "Qu3r0@2018"
    And I click on "Sign in"
    Then I'm logged in
