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

    private def after(seconds)

    end
  end
end