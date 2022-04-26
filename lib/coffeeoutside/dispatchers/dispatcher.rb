# frozen_string_literal: true

module CoffeeOutside
  class DispatcherBase
    attr_reader :start_time, :end_time, :location, :forecast

    def initialize(config)
      @start_time = config[:start_time]
      @end_time = config[:end_time]
      @location = config[:location]
      @forecast = config[:forecast]
      @production = config[:production]
      # Save parameters for further use by subclasses
      @params = config
    end

    def production?
      @production
    end

    def notify
      production? ? notify_production : debug_method
    end

    def notify_production
      raise 'notify_production must be overridden'
    end

    def debug_method
      puts "\n"
      puts self.class
      notify_debug
    end

    def notify_debug
      raise 'notify_production must be overridden'
    end
  end
end
