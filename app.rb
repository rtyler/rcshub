#!/usr/bin/env ruby

require 'rubygems'
require 'haml'
require 'json'
require 'redis'
require 'sinatra'

require File.dirname(__FILE__) + "/lib/rcshub/github"



before do
  @api = RCSHub::API::GitHub.new
  @api.cache = Redis.new({:host => "localhost", :port => 6380})
end

get '/' do
  erb :home
end

get "/:username" do |username|
  @repos = @api.repos_for_user(username)
  @username = username
  haml :profile
end

