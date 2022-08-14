# frozen_string_literal: true

require_relative "dispatcher"
require "rss"

module CoffeeOutside
  class RssDispatcher < DispatcherBase
    def generate_description
      items = []
      items.append(["Address: #{@location.address}"]) if @location.address
      items.append(@forecast)
      items.join("\n")
    end

    def generate_rss_string
      RSS::Maker.make("2.0") do |maker|
        maker.channel.language = "en"
        maker.channel.author = "CoffeeOutsideBot"
        maker.channel.updated = Time.now.to_s
        maker.channel.about = "https://coffeeoutside.bike/yyc.rss"
        maker.channel.link = "https://coffeeoutside.bike/yyc.rss"
        maker.channel.description = "CoffeeOutside is a weekly meetup where Calgarians bike/walk/run/rollerblade to a location, drink coffee/tea/some hot or cold beverage, and shoot the breeze" # rubocop:disable Layout/LineLength
        maker.channel.title = "CoffeeOutside"

        maker.items.new_item do |item|
          item.link = @location.url if @location.url
          item.title = "Location for #{@start_time.strftime("%Y-%m-%d")}: #{@location.name}"
          item.description = generate_description
          item.updated = Time.now.to_s
        end
      end
    end

    def notify_production
      i = File.open("yyc.rss", "w")
      i.write(generate_rss_string)
    end

    def notify_debug
      puts generate_rss_string
    end
  end
end
