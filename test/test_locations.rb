# frozen_string_literal: true

require "test_helper"

class CoffeeOutsideTest < Minitest::Test
  include CoffeeOutside
  def test_rainy_day_location
    loc = Location.new("name" => "test", "rainy_day" => true)
    fc = Minitest::Mock.new
    fc.expect :rainy?, true
    assert_equal true, loc.weather_appropriate?(fc)
    fc.expect :rainy?, false
    assert_equal true, loc.weather_appropriate?(fc)
  end

  def test_sunny_day_location
    loc = Location.new("name" => "test", "rainy_day" => false)
    fc = Minitest::Mock.new
    fc.expect :rainy?, true
    assert_equal false, loc.weather_appropriate?(fc)
    fc.expect :rainy?, false
    assert_equal true, loc.weather_appropriate?(fc)
  end

  def test_hi_temp_location
    loc = Location.new("name" => "test", "high_limit" => 1)
    fc = Minitest::Mock.new
    fc.expect :rainy?, false
    fc.expect :temperature, 2
    assert_equal false, loc.weather_appropriate?(fc)
    fc.expect :rainy?, false
    fc.expect :temperature, 0
    assert_equal true, loc.weather_appropriate?(fc)
  end

  def test_lo_temp_location
    loc = Location.new("name" => "test", "low_limit" => 1)
    fc = Minitest::Mock.new
    fc.expect :rainy?, false
    fc.expect :temperature, 0
    assert_equal false, loc.weather_appropriate?(fc)
    fc.expect :rainy?, false
    fc.expect :temperature, 2
    assert_equal true, loc.weather_appropriate?(fc)
  end
end
