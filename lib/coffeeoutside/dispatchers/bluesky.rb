# frozen_string_literal: false

# rbs_inline: enabled

require_relative "dispatcher"
require "json"
require "http"
require "time"

module CoffeeOutside
  module Dispatchers
    class Bluesky < DispatcherBase
      def notify_production
        return "Could not find identifier, skipping Bluesky dispatcher" unless @params["identifier"]
        return "Could not find password, skipping Bluesky dispatcher" unless @params["password"]

        host = @params["host"] || "https://bsky.social"

        # Create session to authenticate and get access JWT
        session_url = "#{host}/xrpc/com.atproto.server.createSession"
        session_resp = HTTP.post(session_url, json: {
                                   identifier: @params["identifier"],
                                   password: @params["password"]
                                 })

        raise "Failed to authenticate with Bluesky: #{session_resp.body}" unless session_resp.status.success?

        session_data = JSON.parse(session_resp.body.to_s)
        access_jwt = session_data["accessJwt"]
        did = session_data["did"]

        msg = location_skeet_msg
        record = {
          "$type": "app.bsky.feed.post",
          text: msg,
          createdAt: Time.now.utc.iso8601
        }
        f = facets(msg)
        record[:facets] = f unless f.empty?

        # Post the skeet using the session JWT
        post_url = "#{host}/xrpc/com.atproto.repo.createRecord"
        post_resp = HTTP.headers({ Authorization: "Bearer #{access_jwt}" })
                        .post(post_url, json: {
                                repo: did,
                                collection: "app.bsky.feed.post",
                                record: record
                              })

        raise "Failed to post to Bluesky: #{post_resp.body}" unless post_resp.status.success?
      end

      def notify_debug
        puts "Bluesky identifier = #{@params["identifier"]}"
        msg = location_skeet_msg
        puts msg
        f = facets(msg)
        puts "Facets: #{JSON.generate(f)}" unless f.empty?
        puts "\n"
      end

      def facets(text)
        facets_list = []

        # Identify links
        text.scan(%r{https?://[^\s,)]+}) do |url|
          m = Regexp.last_match
          b_start = text[0...m.begin(0)].bytesize
          b_end = b_start + url.bytesize
          facets_list << {
            index: { byteStart: b_start, byteEnd: b_end },
            features: [{ "$type": "app.bsky.richtext.facet#link", uri: url }]
          }
        end

        # Identify hashtags
        text.scan(/#[a-zA-Z0-9_]+/) do |tag|
          m = Regexp.last_match
          b_start = text[0...m.begin(0)].bytesize
          b_end = b_start + tag.bytesize
          facets_list << {
            index: { byteStart: b_start, byteEnd: b_end },
            features: [{ "$type": "app.bsky.richtext.facet#tag", tag: tag[1..] }]
          }
        end

        facets_list
      end

      def location_skeet_msg #: String
        str = "This week's #CoffeeOutside: #{@location.name}"
        str << " (#{@location.location_hint})" if @location.location_hint
        if @location.url
          str << " #{@location.url}"
        elsif @location.map_url
          str << " #{@location.map_url}"
        end
        str << " (#{@location.address})" if @location.address
        str << ", see you there! #yycbike"
        str
      end
    end
  end
end
