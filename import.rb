#!/usr/bin/env ruby

require 'rubygems'

require File.dirname(__FILE__) + "/lib/rcshub/converter.rb"

converter = RCSHub::Converter.new(:root => Dir.pwd)
converter.convert
puts "Converted #{converter.count} commits"

