# frozen_string_literal: true

# rbs_inline: enabled

require_relative "dispatcher"
require "json"

module CoffeeOutside
  module Dispatchers
    class Json < DispatcherBase
      def generate_json_blob #: String
        location = {
          name: @location.name,
          url: @location.url
        }
        location[:address] = @location.address if @location.address
        ::JSON.dump({ location: location })
      end

      def notify_production
        i = File.open("yyc.json", "w")
        i.write(generate_json_blob)
      end

      def notify_debug #: String
        puts generate_json_blob
      end
    end
  end
end
