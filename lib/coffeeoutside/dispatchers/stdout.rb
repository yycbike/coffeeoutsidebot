# frozen_string_literal: true

require_relative 'dispatcher'

module CoffeeOutside
  class StdoutDispatcher < DispatcherBase
    def notify_production
      # Since the bot is cron-based, don't write anything to stdout unless
      # there's a problem
      # puts "Chosen location is #{@location.name}"
    end

    def notify_debug
      puts "Chosen location is #{@location.name}"
    end
  end
end
