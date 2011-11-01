Feature: Convert a git repository to RCS

    Scenario: Convert a non-imported repo
        Given a repository that has never been converted
        When I ask for it to be imported
        Then I should see a convert job enqueued
        And I should see a worker spin up
        And I should be given the RCS repo

    Scenario: Re-use an existing imported repo
        Given a repository that has been converted already
        When I ask for it to be imported
        Then I should see no jobs enqueued
        And I should be given the RCS repo

    Scenario: Update an existing but out of date imported repo
        Given a repository that has been converted already
        And the repository is out of date
        When I ask for it to be imported
        Then I should see an update job enqueued
        And I should see a worker spin up
        And I should be given the RCS repo
