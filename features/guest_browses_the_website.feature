@guest @guest-browses-the-website @javascript
Feature: Guest browses the web site

  As a guest
  I want to browse the website
  So I can get

  @guest-browses-the-website-1
  Scenario Outline: Guest access the home page
    Given My browser is set to "<language>"
    When I visit "<url>"
    Then I can see the page content

  Examples:
   | language | url             |
   | en       | root_path       |
   | pt-BR    | root_path       |
   | en       | courses_path    |
   | pt-BR    | courses_path    |
