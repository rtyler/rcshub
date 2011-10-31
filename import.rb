#!/usr/bin/env ruby

require 'rubygems'

require File.dirname(__FILE__) + "/lib/rcshub/converter.rb"

converter = RCSHub::Converter.new({:root => Dir.pwd, :threaded => false})
converter.convert
puts "Converted #{converter.count} commits into #{converter.work_dir}"
if converter.threaded
  puts "used threads"
else
  puts "single-threaded"
end

