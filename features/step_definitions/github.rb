require File.dirname(__FILE__) + "/../../lib/rcshub/github.rb"

Before do
  @username = "example"
  @api = RCSHub::API::GitHub.new
end

Given /^a user with some repos$/ do
  @repos = ["test"]
  @api.stubs(:fetch_repos_for).returns(@repos)
end

Given /^an empty cache$/ do
  @api.cache.stubs(:get).returns(nil)
end

Given /^I expect to cache the repos$/ do
  # This is crap, I'm setting up my expectation in the wrong step. Not sure how
  # to accomplish this properly just yet
  @api.cache.expects(:set).with("#{@api.class::REPOS_CACHE_KEY}#{@username}", @repos)
end

When /^I hit the repos API$/ do
  @result = @api.repos_for_user(@username)
end

Then /^I should have a list of repos$/ do
  @result.should == @repos
end

Then /^I should have cached that list of repos$/ do
  mocha_verify
end

Given /^those repos are cached$/ do
  @api.cache.expects(:get).returns(@repos)
  @api.expects(:fetch_repos_for).never
end

Then /^I should not have accessed the API$/ do
  mocha_verify
end

