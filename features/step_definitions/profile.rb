require 'rubygems'
require 'mocha'
require 'octopi'

Before do
  @username = "fakeuser"
  @mocked_user = Mocha::Mock.new
  @mocked_user.stubs(:name).returns(@username)
  @mocked_user.stubs(:repositories).returns([])

  Octopi::User.stubs(:find).returns(@mocked_user)
end

Given /^a user named "([^"]*)"$/ do |name|
  @mocked_user.stubs(:name).returns(name)
end

Given /^a user with (\d+) repositories$/ do |count|
  repos = []
  count.to_i.times do |i|
    repo = Octopi::Repository.new
    repo.stubs(:name).returns("repo_#{i}")
    repos << repo
  end
  @mocked_user.stubs(:repositories).returns(repos)
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
