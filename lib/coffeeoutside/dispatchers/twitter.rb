# frozen_string_literal: false

require_relative "dispatcher"
require "json"
require "twitter"

module CoffeeOutside
  class TwitterDispatcher < DispatcherBase
    def notify_production
      # Configure client
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = @params["consumer_key"]
        config.consumer_secret     = @params["consumer_secret"]
        config.access_token        = @params["token"]
        config.access_token_secret = @params["token_secret"]
      end

      # Send location tweet
      t = client.update location_tweet_msg # rubocop:disable Lint/UselessAssignment
      # puts t

      # Send followup tweets
      # client.update('test', { in_reply_to_status_id: t.id }) if t.id
    end

    def notify_debug
      puts "consumer_key        = #{@params["consumer_key"]}"
      puts "consumer_secret     = #{@params["consumer_secret"]}"
      puts "access_token        = #{@params["token"]}"
      puts "access_token_secret = #{@params["token_secret"]}"
      puts location_tweet_msg
      puts "\n"
    end

    def location_tweet_msg
      str = "This week's #CoffeeOutside: #{@location.name}"
      str << " (#{@location.location_hint})" if @location.location_hint
      str << " #{@location.url}" if @location.url
      str << " (#{@location.address})" if @location.address
      str << ", see you there! #yycbike"
      str
    end

    def weather_tweet_msg
      # TODO
    end

    def nearby_locations_tweet_msg
      # TODO
    end
  end
end
