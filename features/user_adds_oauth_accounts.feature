@user @user-adds-oauth-accounts @javascript
Feature: User adds oauth accounts

  As a user
  I want to connect my Classpert account with multiple oauth accounts
  So I can fill my profile and improve my logged experience

  Scenario: User connects with one account
    Given I am signed in
    When I connect with my "github" account
    Then my current account is associated with my "github" account

  Scenario: User connects with multiple oauth accounts
    Given I am signed in
    And I already have an associated github account
    When I connect with my "linkedin" account
    Then my current account is associated with "github" and "linkedin" accounts

