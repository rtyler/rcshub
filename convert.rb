#!/usr/bin/env ruby

require 'rubygems'
require 'temp_dir'
require 'grit'

def walk_tree(tree)
  tree.contents.each do |subtree|
    if subtree.instance_of? Grit::Tree
      walk_tree(subtree)
    else
      puts "#{subtree.id} - #{subtree.name} - #{subtree.mode} - #{subtree.size}"
    end
  end
end

def run
  repo = Grit::Repo.new(File.dirname(__FILE__))
  repo.commits.each do |commit|
    shortname = commit.author.email.split("@").first
    puts "#{shortname} - #{commit.id}"
    walk_tree(commit.tree)
    puts "----"
  end
end

run
