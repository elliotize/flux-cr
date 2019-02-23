module Fluxcr
  class Leds
    def initialize(@leds : Array(Led))
    end

    def get_statuses
      channel = Channel(NamedTuple(
        led: Fluxcr::Led,
        status: Fluxcr::LedStatusResponse
      )).new

      @leds.each do |led|
        spawn do
          channel.send({led: led, status: led.get_status})
        end
      end

      spawn do
        sleep 10
        channel.close
      end

      @leds.each do |led|
        status_response = channel.receive
        yield status_response[:led], status_response[:status]
      end
    end

    def turn_all_on
      @leds.each do |led|
        led.set_on
      end
    end

    def turn_all_off
      @leds.each do |led|
        led.set_off
      end
    end
  end
end