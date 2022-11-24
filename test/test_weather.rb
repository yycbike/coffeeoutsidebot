# frozen_string_literal: true

require "test_helper"

class CoffeeOutsideTest < Minitest::Test
  include CoffeeOutside
  def test_forecast_class
    sunny_day = Forecast.new(humidity: 0, temperature: 15)
    assert_equal sunny_day.temperature, 15
    assert_equal sunny_day.rainy?, false
    crappy_day = Forecast.new(humidity: 100, temperature: 2)
    assert_equal crappy_day.temperature, 2
    assert_equal crappy_day.rainy?, true
  end

  def test_owm_forecast
    # This test confirms that the bot will pick up the forecast right
    # before CoffeeOutside
    fc_fixture = OpenWeatherMap::Forecast.new(File.read("#{__dir__}/owm_fixture.json"))
    mock_owm = OWM.new({ "city_id" => "1", "api_key" => "x" },
                       DateTime.new(2022, 11, 25, 7, 30, 0, "-07:00"))
    mock_owm.result = fc_fixture
    assert mock_owm.closest_forecast.time.to_datetime, DateTime.new(2022, 11, 25, 5, 0, 0, "-07:00")
  end
end
