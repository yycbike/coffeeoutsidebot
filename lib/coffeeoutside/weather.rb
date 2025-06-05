# frozen_string_literal: true

# rbs_inline: enabled

require "openweathermap"

module CoffeeOutside
  class OWM
    attr_accessor :result

    def initialize(config, time = DateTime.now)
      @city_id = config["city_id"]
      @api_key = config["api_key"]
      @start_time = time
    end

    def api_call
      api = OpenWeatherMap::API.new(@api_key, "en", "metric")
      @result = api.forecast(@city_id)
    end

    def closest_forecast
      # Doing this as 'The Price Is Right' rules, forecast with the closest
      # time to the start without going over wins.
      @result.forecast.reject! { |x| x.time.to_datetime > @start_time }
      @result.forecast.last
    end

    def forecast #: Forecast
      api_call
      fc = closest_forecast
      Forecast.new(humidity: fc.humidity, temperature: fc.temperature)
    end
  end

  HUMIDITY_LIMIT = 90 #: Integer
  class Forecast
    #: (Hash[Symbol, Integer] hash) -> untyped
    def initialize(hash)
      @humidity = hash[:humidity] || 0
      @temperature = hash[:temperature] || 0
    end

    def rainy? #: bool
      # TODO: could also regex for "rain" or "snow" from OWM...
      @humidity >= HUMIDITY_LIMIT
    end

    attr_reader :temperature #: Integer

    def to_s #: String
      "Forecast is temp of #{@temperature} humidity #{@humidity}"
    end
  end
end
