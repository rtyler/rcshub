#!/usr/bin/env ruby

require 'rubygems'
require 'haml'
require 'json'
require 'sinatra'

require File.dirname(__FILE__) + "/lib/rcshub/github"

before do
  @api = RCSHub::API::GitHub.new
end

get '/' do
  "Hello, world!"
end

get "/:username" do |username|
  @repos = @api.repos_for_user(username)
  @username = username
  haml :profile
end
