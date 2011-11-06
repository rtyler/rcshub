@views
Feature: Build a user profile
  In order to find RCS repos to clone
  As a user
  I want to see a listing of a github user's events and projects

  Scenario: Viewing a profile
    Given a user named "mike"
    When I visit the user's profile
    Then the title should contain "Index of /mike"

  Scenario: View a profile with no repos
    Given a user with 0 repositories
    When I visit the user's profile
    And I should see 0 repositories

  Scenario: View a profile with a single repo
    Given a user with 1 repositories
    When I visit the user's profile
    Then I should see 1 repositories

# vim: ft=cucumber sw=2 ts=2 et
