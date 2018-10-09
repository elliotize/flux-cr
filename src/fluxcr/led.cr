require "socket"

module Fluxcr
  class Led
    getter :uuid

    def self.from_raw_response(led_response : String) : Led
      parts = led_response.split(",")
      socket = TCPSocket.new(parts[0], 5577)
      new(parts[0], parts[1], socket)
    end

    def self.connect(ip : String, uuid : String) : Led
      socket = TCPSocket.new(ip, 5577)
      new(ip, uuid, socket)
    end

    def initialize(@ip : String, @uuid : String, @socket : TCPSocket)
    end

    def set_color(red : UInt8, green : UInt8, blue : UInt8) : Void
      data = Slice[UInt8.new(49), red, green, blue, UInt8.new(0), UInt8.new(240), UInt8.new(15)]
      send(data)
    end

    def set_warm(level : UInt8) : Void
      data = Slice[UInt8.new(49), UInt8.new(0), UInt8.new(0), UInt8.new(0), level, UInt8.new(15), UInt8.new(240)]
      send(data)
    end

    def set_off : Void
      data = Slice[UInt8.new(113), UInt8.new(36), UInt8.new(15)]
      send(data)
    end

    def set_on : Void
      data = Slice[UInt8.new(113), UInt8.new(35), UInt8.new(15)]
      send(data)
    end

    def get_status
      data = Slice[UInt8.new(129), UInt8.new(138), UInt8.new(139)]
      send_and_recieve(data)
    end

    private def send_and_recieve(data : Slice) : LedStatusResponse
      response_channel = Channel(LedStatusResponse).new
      spawn do
        bytes = Slice(UInt8).new(14)
        @socket.read_fully(bytes)
        response_channel.send(LedStatusResponse.from_raw_byte_response(bytes))
      end
      send(data)
      response_channel.receive
    end
  
    private def send(data : Slice)
      request = Slice.new(data.size + 1, UInt8.new(0))
      request[data.size] = UInt8.new(data.to_a.sum)
      data.move_to request
      @socket.send request
    end
  end
end
