require 'rubygems'
require 'fileutils'
require 'grit'
require 'temp_dir'


module RCSHub
  class Converter
    attr_accessor :count

    def initialize(opts=nil)
      opts ||= {}
      root = opts[:root] || Dir.pwd
      @repo = Grit::Repo.new(root)
      @work_dir = TempDir.create(:rootpath => root)
      @count = 0

      @author = nil
    end

    def walk_tree(commit, file_path, tree, seen)
      tree.contents.each do |subtree|
        if subtree.instance_of? Grit::Tree
          tree_path = "#{file_path}/#{subtree.name}"
          FileUtils.mkdir_p(tree_path + "/RCS")
          walk_tree(commit, "#{file_path}/#{subtree.name}", subtree, seen)
          next
        end


        unless seen[subtree.id]
          seen[subtree.id] = true

          object_path = "#{file_path}/#{subtree.name}"

          message = "#{commit.message}\n\nrcshub: #{commit.id}"

          unless subtree.size <= 0
            fd = File.new(object_path, 'w')
            fd.write(subtree.data)
            fd.close
            print %x{echo "#{message}" | ci -l -w#{@author} "#{object_path}"}
          else
            puts "#{subtree.name} empty, skipping"
          end
        end
      end
    end

    def convert
      rcs_path = @work_dir + "/RCS"

      puts "Using work directory: #{@work_dir}"
      Dir.mkdir(rcs_path)
      seen = {}

      @repo.commits('master', false).reverse_each do |commit|
        @count += 1
        @author = commit.author.email.split("@").first
        walk_tree(commit, @work_dir, commit.tree, seen)
        puts "----------------"
      end
    end
  end
end

