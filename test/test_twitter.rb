# frozen_string_literal: true

require "helper"

class CoffeeOutsideTest < Minitest::Test
  def test_location_tweet_msg
    dispatcher = ::CoffeeOutside::TwitterDispatcher.new({
                                                          location: ::CoffeeOutside::Location.new(
                                                            "name" => "Tomkins Park",
                                                            "address" => "17th Ave",
                                                            "url" => "https://example.org"
                                                          )
                                                        })
    assert_equal dispatcher.location_tweet_msg,
                 "This week's #CoffeeOutside: Tomkins Park https://example.org (17th Ave), see you there! #yycbike"

    dispatcher = ::CoffeeOutside::TwitterDispatcher.new({
                                                          location: ::CoffeeOutside::Location.new(
                                                            "name" => "Tomkins Park",
                                                            "url" => "https://example.org"
                                                          )
                                                        })
    assert_equal dispatcher.location_tweet_msg,
                 "This week's #CoffeeOutside: Tomkins Park https://example.org, see you there! #yycbike"

    dispatcher = ::CoffeeOutside::TwitterDispatcher.new({
                                                          location: ::CoffeeOutside::Location.new(
                                                            "name" => "Tomkins Park"
                                                          )
                                                        })
    assert_equal dispatcher.location_tweet_msg, "This week's #CoffeeOutside: Tomkins Park, see you there! #yycbike"
  end

  def test_weather_tweet_msg
    dispatch = {
      forecast: ::CoffeeOutside::Forecast.new(humidity: 0, temperature: 10)
    }
  end
end
