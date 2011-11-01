require 'rubygems'
require 'mocha'
require 'octopi'

Given /^a user named "([^"]*)"$/ do |name|
  @username = name
end

Given /^a user with (\d+) repositories$/ do |count|
  @username = "fakeuser"
  @user = Mocha::Mock.new
  repos = []
  count.to_i.times do
    repos << Octopi::Repository.new
  end
  @user.stubs(:repositories).returns(repos)
end

When /^I visit the user's profile$/ do
  visit "/#{@username}"
end

Then /^I should see (\d+) repositories$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Given /^a user with (\d+) timeline events$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^I should see (\d+) timeline events$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end
