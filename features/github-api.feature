Feature: A caching GitHub API

    Scenario: Accessing a user's repos (uncached)
        Given a user with some repos
        And an empty cache
        And I expect to cache the repos
        When I hit the repos API
        Then I should have a list of repos
        And I should have cached that list of repos

    Scenario: Accessing a user's repos (cached)
        Given a user with some repos
        And those repos are cached
        When I hit the repos API
        Then I should have a list of repos
        And I should not have accessed the API
