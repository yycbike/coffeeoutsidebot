# frozen_string_literal: true

require "openweathermap"

module CoffeeOutside
  class OWM
    def initialize(config)
      @city_id = config["city_id"]
      @api_key = config["api_key"]

      forecast
    end

    def api_call
      api = OpenWeatherMap::API.new(@api_key, "en", "metric")
      api.forecast(@city_id)
    end

    def forecast
      # TODO: this looks wrong, check @time!
      fc = api_call.forecast[2]
      Forecast.new(humidity: fc.humidity, temperature: fc.temperature)
    end
  end

  HUMIDITY_LIMIT = 75
  class Forecast
    def initialize(hash)
      @humidity = hash[:humidity] || 0
      @temperature = hash[:temperature] || 0
    end

    def rainy?
      # TODO: could also regex for "rain" or "snow" from OWM...
      @humidity >= HUMIDITY_LIMIT
    end

    attr_reader :temperature

    def to_s
      "Forecast is temp of #{@temperature} humidity #{@humidity}"
    end
  end
end
