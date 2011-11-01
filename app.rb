#!/usr/bin/env ruby

require 'rubygems'
require 'octopi'
require 'sinatra'

get '/' do
  "Hello, world!"
end

get "/:username" do |username|
  @user = Octopi::User.find(username)
  haml :profile
end
