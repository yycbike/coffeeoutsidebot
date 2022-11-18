# frozen_string_literal: true

require "test_helper"

class CoffeeOutsideTest < Minitest::Test
  include CoffeeOutside
  def test_location_tweet_msg
    [
      [
        {
          "name" => "Tomkins Park",
          "location_hint" => "by the stage",
          "url" => "https://example.org"
        },
        "This week's #CoffeeOutside: Tomkins Park (by the stage) https://example.org, see you there! #yycbike"
      ],
      [
        {
          "name" => "Tomkins Park",
          "address" => "17th Ave",
          "url" => "https://example.org"
        },
        "This week's #CoffeeOutside: Tomkins Park https://example.org (17th Ave), see you there! #yycbike"
      ],
      [
        {
          "name" => "I Love You Coffee Shop",
          "twitter" => "@iloveyoucoffee_",
          "url" => "https://iloveyoucoffeeshop.com"
        },
        "This week's #CoffeeOutside: @iloveyoucoffee_ https://iloveyoucoffeeshop.com, see you there! #yycbike"
      ],
      [
        { "name" => "Tomkins Park",
          "url" => "https://example.org" },
        "This week's #CoffeeOutside: Tomkins Park https://example.org, see you there! #yycbike"
      ],
      [
        { "name" => "Tomkins Park" },
        "This week's #CoffeeOutside: Tomkins Park, see you there! #yycbike"
      ]
    ].each do |location, string|
      dispatcher = TwitterDispatcher.new(
        {
          location: Location.new(location)
        }
      )
      assert_equal dispatcher.location_tweet_msg,
                   string, location
    end
  end

  # def test_weather_tweet_msg
  #  dispatch = {
  #    forecast: ::CoffeeOutside::Forecast.new(humidity: 0, temperature: 10)
  #  }
  # end
end
