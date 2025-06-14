# frozen_string_literal: true

# rbs_inline: enabled

require "yaml"

module CoffeeOutside
  class Location
    attr_reader :name, :location_hint, :address, :url, :nearby_coffee

    #: (Hash[String, untyped] params) -> untyped
    def initialize(params)
      if params["name"]
        @name = params["name"]
      else
        raise "Location class requires name key"
      end
      @paused = params["paused"] || false
      @nearby_coffee = params["nearby_coffee"] || []
      @url = params["url"] if params["url"]
      @address = params["address"] if params["address"]
      @location_hint = params["location_hint"] if params["location_hint"]

      # Forecast related
      @rainy_day = params["rainy_day"] || false
      @high_limit = params["high_limit"] if params["high_limit"]
      @low_limit = params["low_limit"] if params["low_limit"]

      # Save params for any dispatcher-specific values
      @params = params
    end

    def paused? #: bool
      @paused
    end

    #: (Forecast forecast) -> bool
    def weather_appropriate?(forecast)
      # TODO: stderr reasons?

      return false if (forecast.rainy? && !@rainy_day) ||
                      (@low_limit && (forecast.temperature < @low_limit)) ||
                      (@high_limit && (forecast.temperature > @high_limit))

      true
    end

    def to_s #: String
      @name
    end
  end

  class LocationFile
    attr_reader :locations #: Array[Location]

    #: (?String filename) -> Array[Location]
    def initialize(filename = "./locations.yaml")
      y = YAML.load_file(filename)
      @locations = []
      y.each do |l|
        @locations.append Location.new(l)
      end
      @locations # rubocop:disable Lint/Void
    end
  end

  class OverrideFile
    attr_reader :location #: Location

    #: (?String filename) -> untyped
    def initialize(filename = "./override.yaml")
      @filename = filename
      if ::File.exist? @filename
        @override = true
        @location = Location.new(YAML.load_file(filename))
      else
        @override = false
        @location = nil
      end
    end

    def override? #: bool
      @override
    end

    def delete_file
      ::File.delete @filename
    end
  end

  class LocationChooser
    attr_reader :location #: Location

    #: (Forecast forecast, ?destructive: bool) -> untyped
    def initialize(forecast, destructive: false)
      @location = nil
      of = OverrideFile.new
      plf = PriorLocationsFile.new

      # First check override file
      if of.override?
        @location = of.location
        of.delete_file if destructive
      else
        # If no override location, determine one
        locations = LocationFile.new.locations

        # Remove paused locations
        locations.delete_if(&:paused?)

        # Delete locations that don't meet forecast criteria
        locations.keep_if { |l| l.weather_appropriate? forecast }

        # Raise if no locations remaining
        raise "No locations remaining!" if locations.empty?

        # Remove previously selected locations
        prior_locations = plf.previous_locations.dup
        while !prior_locations.empty? && locations.count > 1
          pl = prior_locations.pop(locations.count - 1)
          locations.delete_if { |l| pl.include? l.name }
        end

        # Pick random location if more than one remaining
        @location = locations.sample
      end

      # Append to prior locations list
      plf.append_location @location if destructive

      @location # rubocop:disable Lint/Void
    end
  end

  class PriorLocationsFile
    #: (?String filename) -> untyped
    def initialize(filename = "./prior_locations.yaml")
      @filename = filename
      @locations = if File.exist? filename
                     YAML.load_file(filename) || []
                   else
                     []
                   end
    end

    def previous_locations #: Array[Location]
      @locations
    end

    #: (Location location) -> untyped
    def append_location(location)
      @locations.append location.name
      f = File.open(@filename, "w")
      f.write(YAML.dump(@locations))
    end
  end
end
