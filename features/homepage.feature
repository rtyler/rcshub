Feature: Generate a fancy homepage


  Scenario: visiting the home page
    Given I am a browser
    When I visit "/"
    Then I should see "Hello, world!"
