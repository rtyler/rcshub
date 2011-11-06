require 'rubygems'
require 'json'
require File.dirname(__FILE__) + "/../../lib/rcshub/github.rb"

Before do
  @username = "example"
  @api = RCSHub::API::GitHub.new
  @api.cache = Mocha::Mock.new
  @api.stubs(:get).returns(DUMMY_RESPONSE)
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
  @api.cache.expects(:setex).with("#{@api.class::REPOS_CACHE_KEY}#{@username}", @api.class::CACHE_EXPIRE, JSON.dump(@repos))
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
  @api.cache.expects(:get).returns(JSON.dump(@repos))
  @api.expects(:fetch_repos_for).never
end

Then /^I should not have accessed the API$/ do
  mocha_verify
end


DUMMY_RESPONSE = [{"name"=>"test",
  "master_branch"=>nil,
  "size"=>0,
  "created_at"=>"2009-02-25T19:02:12Z",
  "clone_url"=>"https://github.com/example/test.git",
  "watchers"=>1,
  "private"=>false,
  "updated_at"=>"2011-10-03T23:39:52Z",
  "ssh_url"=>"git@github.com:example/test.git",
  "language"=>nil,
  "fork"=>false,
  "url"=>"https://api.github.com/repos/example/test",
  "git_url"=>"git://github.com/example/test.git",
  "id"=>137494,
  "svn_url"=>"https://svn.github.com/example/test",
  "pushed_at"=>nil,
  "open_issues"=>0,
  "homepage"=>"test",
  "forks"=>0,
  "description"=>"test",
  "html_url"=>"https://github.com/example/test",
  "owner"=>
   {"gravatar_id"=>"e820bb4aba5ad74c5a6ff1aca16641f6",
    "avatar_url"=>
     "https://secure.gravatar.com/avatar/e820bb4aba5ad74c5a6ff1aca16641f6?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png",
    "url"=>"https://api.github.com/users/example",
    "id"=>57936,
    "login"=>"example"}}]
