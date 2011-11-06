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

      private

      def fetch_repos_for(username)
        return self.class.get("#{BASE_URL}/users/#{username}/repos")
      end

    end
  end
end
