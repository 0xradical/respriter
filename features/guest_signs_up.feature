@guest @guest-signs-up @javascript
Feature: Guest signs up

  As a guest
  I want to sign up at Quero
  So I can have access to user content

  @guest-signs-up-1
  Scenario: Guest successfull sign up with email
    Given I visit the sign up page
    When I fill my email "john.doe@quero.com" and my password "Qu3r0@2018"
    And I click on "Sign up"
    Then an user account with email "john.doe@quero.com" is created
    And I can see my dashboard

  @guest-signs-up-2
  Scenario Outline: Guest unsuccessfull sign up with email
    Given I visit the sign up page
    When I fill my email "<email>" and my password "<password>"
    And I click on "Sign up"
    Then an user account with email "<email>" is not created
    #And I receive a "<failure>" message


    Examples:

    | email                                | password                 |
    | not-a-valid-email@@hotmail.com       | valid_password_0101      |
    | not-an-allowed-domain@mailinator.com | valid_password_0101      |
    | john.doe@no-mx-record-found-82637382 | valid_password_0101      |
    | john.doe@quero.com                   | short                    |

  # @guest-signs-up-3
  # Scenario Outline: Guest successfull sign up with oauth
    # Given I visit the sign up page
    # When I connect with my "<oauth>" account
    # Then an user account with email "john.doe@quero.com" is created and associated with "<oauth>"

    # Examples:

    # | oauth     |
    # | linkedin  |
    # | github    |

  # @guest-signs-up-4
  # Scenario Outline: Guest unsuccessfull sign up with oauth
    # Given I visit the sign up page
    # When I connect with my "<oauth>" account
    # And my email is missing
    # #Then I am redirected to the restricted content

    # Examples:

    # | oauth     |
    # | linkedin  |
    # | github    |

