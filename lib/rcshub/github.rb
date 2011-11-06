#!/usr/bin/env ruby

require 'rubygems'
require 'httparty'

module RCSHub
  module API
    class GitHub
      include HTTParty
      format :json
      BASE_URL = "https://api.github.com"

      attr_accessor :cache
      REPOS_CACHE_KEY = "repos-for:"
      TREE_CACHE_KEY  = "tree-for:"
      CACHE_EXPIRE = 60 * 5


      def initialize
        @cache = nil
        super
      end

      def repos_for_user(username)
        key = "#{REPOS_CACHE_KEY}#{username}"

        unless @cache.nil?
          if result = @cache.get(key)
            return JSON.load(result)
          end
        end

        result = fetch_repos_for(username)
        @cache.setex(key, CACHE_EXPIRE, JSON.dump(result)) unless @cache.nil?
        return result
      end

      def tree_for(username, repo)
        key = "#{TREE_CACHE_KEY}#{username}"

        unless @cache.nil?
          if result = @cache.get(key)
            return JSON.load(result)
          end
        end

        result = fetch_tree_for(username, repo)
        @cache.setex(key, CACHE_EXPIRE, JSON.dump(result)) unless @cache.nil?
        return result
      end

      private

      def fetch_repos_for(username)
        return self.class.get("#{BASE_URL}/users/#{username}/repos")
      end

      def fetch_tree_for(username, repo)
        return self.class.get("#{BASE_URL}/repos/#{username}/#{repo}/git/trees/HEAD")
      end

    end
  end
end
