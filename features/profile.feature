Feature: Generate a user's RCSHub profile

    Scenario: View a profile with no repos
        Given a user with 0 repositories
        When I visit the user's profile
        Then I should see 0 repositories

    Scenario: View a profile with a single repo
        Given a user with 1 repositories
        When I visit the user's profile
        Then I should see 1 repositories

    Scenario: View a profile with an empty timeline
        Given a user with 0 timeline events
        When I visit the user's profile
        Then I should see 0 timeline events

    Scenario: View a profile with a populated timeline
        Given a user with 1 timeline events
        When I visit the user's profile
        Then I should see 1 timeline events
