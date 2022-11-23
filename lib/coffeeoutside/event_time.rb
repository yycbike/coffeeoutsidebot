# frozen_string_literal: true

module CoffeeOutside
  module EventTime
    def self.next_friday
      # TODO: this is gross...
      @next_friday ||= Date.today + [5, 4, 3, 2, 1, 7, 6][Date.today.wday]
    end

    def self.start_time
      DateTime.new(
        next_friday.year, next_friday.month, next_friday.day,
        7, 30, 0
      )
    end

    def self.end_time
      DateTime.new(
        next_friday.year, next_friday.month, next_friday.day,
        8, 30, 0
      )
    end
  end
end
