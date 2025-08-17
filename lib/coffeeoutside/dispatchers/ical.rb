# frozen_string_literal: true

# rbs_inline: enabled

require_relative "dispatcher"
require "icalendar"

module CoffeeOutside
  module Dispatchers
    class Ical < DispatcherBase
      def generate_ical_string #: String
        format = "%Y%m%dT%H%M%S"
        tzid = "America/Edmonton"

        # Create a calendar with an event (standard method)
        cal = Icalendar::Calendar.new
        cal.event do |e|
          e.dtstart = Icalendar::Values::DateTime.new @start_time.strftime(format), "tzid" => tzid
          e.dtend = Icalendar::Values::DateTime.new @end_time.strftime(format), "tzid" => tzid
          e.summary = "CoffeeOutside - #{@location.name}"
          e.location = "#{@location.address || @location.name} #{@location.location_hint}"
          e.description = "Map URL: #{@location.map_url}" if @location.map_url
        end
        cal.to_ical
      end

      def notify_production
        i = File.open("yyc.ics", "w")
        i.write(generate_ical_string)
      end

      def notify_debug
        puts generate_ical_string
      end
    end
  end
end
