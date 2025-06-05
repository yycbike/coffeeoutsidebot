# frozen_string_literal: false

# rbs_inline: enabled

require_relative "dispatcher"
require "json"
require "http"

module CoffeeOutside
  module Dispatchers
    class Mastodon < DispatcherBase
      def notify_production
        return "Could not find token, skipping Mastodon dispatcher" unless @params["token"]

        # Send location toot
        HTTP.headers({ Authorization: "Bearer #{@params["token"]}" })
            .post("https://yyc.bike/api/v1/statuses/", params: { status: location_toot_msg })
      end

      def notify_debug
        puts "access_token = #{@params["token"]}"
        puts location_toot_msg
        puts "\n"
      end

      def location_toot_msg #: String
        str = "This week's #CoffeeOutside: #{@location.name}"
        str << " (#{@location.location_hint})" if @location.location_hint
        str << " #{@location.url}" if @location.url
        str << " (#{@location.address})" if @location.address
        str << ", see you there! #yycbike"
        str
      end
    end
  end
end
