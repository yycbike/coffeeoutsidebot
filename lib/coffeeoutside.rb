# frozen_string_literal: true

require "yaml"
require "date"
require_relative "coffeeoutside/version"
require_relative "coffeeoutside/locations"
require_relative "coffeeoutside/weather"

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

  def next_friday
    # TODO: this is gross...
    @next_friday ||= Date.today + [5, 4, 3, 2, 1, 7, 6][Date.today.wday]
  end

  def start_time
    DateTime.new(
      next_friday.year, next_friday.month, next_friday.day,
      7, 30, 0
    )
  end

  def end_time
    DateTime.new(
      next_friday.year, next_friday.month, next_friday.day,
      8, 30, 0
    )
  end

  def main
    config = Config.new
    if config.production?
      owm = OWM.new config.openweathermap
      forecast = owm.forecast
    else
      forecast = Forecast.new(humidity: 0, temperature: 10)
    end

    destructive = config.production?
    location = LocationChooser.new(destructive, forecast).location

    dispatch = {
      start_time: start_time,
      end_time: end_time,
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
