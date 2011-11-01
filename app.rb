#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'

get '/' do
  "Hello, world!"
end

get "/:username" do |username|
  @repositories = []
  @username = username
  haml :profile
end
