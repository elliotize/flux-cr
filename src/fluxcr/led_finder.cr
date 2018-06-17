require "socket"

module Fluxcr
  class LedFinder
    def initialize(@socket : UDPSocket = UDPSocket.new)
    end

    def find_leds
      send_broadcast
      led_collect_responses
    end

    private def send_broadcast : Void
      @socket.broadcast = true
      @socket.bind("0.0.0.0", 48899)
      @socket.send("HF-A11ASSISTHREAD", Socket::IPAddress.new("255.255.255.255", 48899))
    end

    private def led_collect_responses : Array
      led_responses = [] of {ip: String, uuid: String} | Nil
      @socket.read_timeout = 1
      attempt_n_times(times: 3, rescue_class: IO::Timeout) do
        led_response, addr = @socket.receive
        led_responses << parse_led_responses(led_response.to_s)
      end
      @socket.close
      led_responses
    end

    private def parse_led_responses(led_response : String) : NamedTuple(ip: String, uuid: String)
      parts = led_response.split(",")
      {
        ip:   parts[0],
        uuid: parts[1],
      }
    end

    private def attempt_n_times(times : Int, rescue_class : Class, &block) : Void
      tries = 0
      while tries < 3
        begin
          yield
        rescue rescue_class
          tries += 1
        end
      end
    end
  end
end
