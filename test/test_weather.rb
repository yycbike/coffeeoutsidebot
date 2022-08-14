# frozen_string_literal: true

require "test_helper"

class CoffeeOutsideTest < Minitest::Test
  def test_forecast_class
    sunny_day = ::CoffeeOutside::Forecast.new(humidity: 0, temperature: 15)
    assert_equal sunny_day.temperature, 15
    assert_equal sunny_day.rainy?, false
    crappy_day = ::CoffeeOutside::Forecast.new(humidity: 100, temperature: 2)
    assert_equal crappy_day.temperature, 2
    assert_equal crappy_day.rainy?, true
  end
end
