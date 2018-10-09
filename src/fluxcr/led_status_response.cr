require "socket"

module Fluxcr
  class LedStatusResponse
    getter :state
    getter :warm_level
    getter :red_level
    getter :green_level
    getter :blue_level

    def self.from_raw_byte_response(raw_byte_response) : LedStatusResponse
      new(
        state: raw_byte_response[2] == UInt8.new(35) ? :on : :off,
        warm_level: raw_byte_response[9],
        red_level: raw_byte_response[6],
        green_level: raw_byte_response[7],
        blue_level: raw_byte_response[8]
      )
    end

    def initialize(@state : Symbol, @warm_level : UInt8, @red_level : UInt8, @green_level : UInt8, @blue_level : UInt8)
    end
  end
end
