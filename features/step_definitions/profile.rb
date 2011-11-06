require 'rubygems'
require 'mocha'

Before do
  @username = 'fakeuser'
end

Given /^a user named "([^"]*)"$/ do |name|
  @username = name
end

Given /^a user with (\d+) repositories$/ do |count|
  repos = []
  count.to_i.times do |i|
    repo = {"name" => "repo_#{i}", "description" => "Simple Repo #{i}"}
    repos << repo
  end
  RCSHub::API::GitHub.any_instance.expects(:repos_for_user).
          with(@username).returns(repos)
end

When /^I visit the user's profile$/ do
  visit "/#{@username}"
end

Then /^I should see (\d+) repositories$/ do |count|
  response_body.should have_selector(".repo_row", :count => count.to_i)
end

Given /^a user with (\d+) timeline events$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^I should see (\d+) timeline events$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end
