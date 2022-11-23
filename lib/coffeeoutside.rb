# frozen_string_literal: true

require "yaml"
require "date"
require_relative "coffeeoutside/version"
require_relative "coffeeoutside/locations"
require_relative "coffeeoutside/weather"
require_relative "coffeeoutside/event_time"

# Dispatchers
%w[stdout json ical rss twitter].each do |d|
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
      owm = OWM.new config.openweathermap
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
    StdoutDispatcher.new(dispatch).notify
    JsonDispatcher.new(dispatch).notify
    RssDispatcher.new(dispatch).notify
    IcalDispatcher.new(dispatch).notify
    TwitterDispatcher.new(dispatch.merge(config.dispatchers["twitter"])).notify
  end
end
