# frozen_string_literal: true

require 'yaml'
require 'date'
require_relative 'coffeeoutside/version'
require_relative 'coffeeoutside/locations'
require_relative 'coffeeoutside/weather'

# Dispatchers
require_relative 'coffeeoutside/dispatchers/json'
require_relative 'coffeeoutside/dispatchers/ical'
require_relative 'coffeeoutside/dispatchers/twitter'

module CoffeeOutside
  class Error < StandardError; end

  class Config
    attr_reader :dispatchers, :openweathermap

    def initialize(config_file = 'config.yaml')
      config = YAML.load_file(config_file)
      @production = config['production']
      @dispatchers = config['dispatchers']
      @openweathermap = config['openweathermap']
    end

    def production?
      @production
    end
  end

  def next_friday
    # TODO: this is gross...
    @next_friday ||= Date.today + [5, 4, 3, 2, 1, 7, 6][Date.today.wday]
  end

  def get_start_time
    DateTime.new(
      next_friday.year, next_friday.month, next_friday.day,
      7, 30, 0
    )
  end

  def get_end_time
    DateTime.new(
      next_friday.year, next_friday.month, next_friday.day,
      8, 30, 0
    )
  end

  def main
    config = Config.new
    if config.production?
      puts config.openweathermap
      owm = OWM.new config.openweathermap
      forecast = owm.get_forecast
    else
      forecast = Forecast.new(humidity: 0, temperature: 10)
    end

    destructive = config.production?
    location = LocationChooser.new(destructive, forecast).location
    puts "Chosen location is #{location}"

    dispatch = {
      start_time: get_start_time,
      end_time: get_end_time,
      forecast: forecast,
      location: location,
      production: config.production?
    }
    JsonDispatcher.new(dispatch).notify
    IcalDispatcher.new(dispatch).notify
    TwitterDispatcher.new(dispatch.merge(config.dispatchers['twitter'])).notify
  end
end
