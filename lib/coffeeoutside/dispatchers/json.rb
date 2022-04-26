# frozen_string_literal: true

require_relative 'dispatcher'
require 'json'

module CoffeeOutside
  class JsonDispatcher < DispatcherBase
    def generate_json_blob
      location = {
        name: @location.name,
        url: @location.url
      }
      ::JSON.dump({ location: location })
    end

    def notify_production
      i = File.open('yyc.json', 'w')
      i.write(generate_json_blob)
    end

    def notify_debug
      puts generate_json_blob
    end
  end
end
