# frozen_string_literal: true
# rbs_inline: enabled

require "yaml"
require "date"
require_relative "coffeeoutside/version"
require_relative "coffeeoutside/locations"
require_relative "coffeeoutside/weather"
require_relative "coffeeoutside/event_time"

# Dispatchers
Dir.glob("*.rb", base: "#{__dir__}/coffeeoutside/dispatchers/").each do |d|
  require_relative "coffeeoutside/dispatchers/#{d}"
end

module CoffeeOutside
  class Error < StandardError; end

  class Config
    attr_reader :dispatchers, :openweathermap

    def initialize(config_file = "config.yaml")
      config = YAML.load_file(config_file)
      @production = config["production"]
      @dispatchers = config["dispatchers"]
      @openweathermap = config["openweathermap"]
    end

    def production?
      @production
    end
  end

  def main
    config = Config.new
    if config.production?
      owm = OWM.new config.openweathermap, EventTime.start_time
      forecast = owm.forecast
    else
      # stub a forecast in since OWM is rate-limited
      forecast = Forecast.new(humidity: 0, temperature: 10)
    end

    location = LocationChooser.new(forecast, destructive: config.production?).location

    dispatch = {
      start_time: EventTime.start_time,
      end_time: EventTime.end_time,
      forecast: forecast,
      location: location,
      production: config.production?
    }

    CoffeeOutside::Dispatchers.constants.each do |d|
      dispatch.merge!(config.dispatchers[d.to_s]) if config.dispatchers[d.to_s]
      ::CoffeeOutside::Dispatchers.const_get(d).new(dispatch).notify
    end
  end
end
