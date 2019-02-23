require "./src/fluxcr"
finder = Fluxcr::LedFinder.new
leds = finder.all_leds
leds.get_statuses do |led, status|
  puts status.state
end

# leds.turn_all_off

# leds.turn_all_on
# leds.turn_all_off