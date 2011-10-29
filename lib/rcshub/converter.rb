require 'rubygems'
require 'fileutils'
require 'grit'
require 'temp_dir'


module RCSHub
  class Converter
    attr_accessor :count
    attr_accessor :work_dir
    attr_accessor :threaded

    def initialize(opts={})
      root = opts[:root] || Dir.pwd
      @threaded = true
      if opts.has_key? :threaded
       @threaded = opts[:threaded]
      end

      @repo = Grit::Repo.new(root)
      @work_dir = TempDir.create(:rootpath => root)
      @count = 0

      @author = nil
    end

    def walk_tree(commit, file_path, tree, seen)
      threads = []
      tree.contents.each do |subtree|

        if subtree.instance_of? Grit::Tree
          tree_path = "#{file_path}/#{subtree.name}"
          FileUtils.mkdir_p(tree_path + "/RCS")
          if @threaded
            threads << Thread.new do
              walk_tree(commit, "#{file_path}/#{subtree.name}", subtree, seen)
            end
          else
            walk_tree(commit, "#{file_path}/#{subtree.name}", subtree, seen)
          end
          next
        end

        unless seen[subtree.id]
          seen[subtree.id] = true

          if subtree.size == 0
            next
          end

          if @threaded
            threads << Thread.new do
              create_commit(file_path, commit, subtree)
            end
          else
            create_commit(file_path, commit, subtree)
          end
        end
      end

      threads.each do |t|
        t.join
      end
    end

    def convert
      rcs_path = @work_dir + "/RCS"

      Dir.mkdir(rcs_path)
      # For bigger repositories, this is going to end up using lots of memory
      seen = {}

      @repo.commits('master', false).reverse_each do |commit|
        @count += 1
        @author = commit.author.email.split("@").first
        walk_tree(commit, @work_dir, commit.tree, seen)
      end
    end

    private

    def create_commit(root_path, commit, subtree)
      object_path = "#{root_path}/#{subtree.name}"

      message = "#{commit.message}\n\nrcshub: #{commit.id}"

      fd = File.new(object_path, 'w')
      fd.write(subtree.data)
      fd.close

      # Creating a tempfile so I can cat it later in the backticks. echo(1)
      # can't handle all the kinds of stupid characters that folks put into
      # commit messages
      #
      # It also seems that I cannot use IO.popen or Open3.popen3 with ci(1) for
      # some reason, broken pipes and bad exit statuses all over the place.
      #
      # Very odd
      tf = Tempfile.new("rcs-commit")
      tf.write message
      tf.flush

      `cat #{tf.path} | ci -l -w#{@author} \"#{object_path}\"`
      unless $?.exitstatus == 0
        puts $?
        puts "BAD EXIT"
        puts subtree.name
        puts message
        puts "----"
        exit 1
      end

      tf.close
      tf.unlink
    end
  end
end

