require "./src/fluxcr"

leds = Fluxcr::LedFinder.new.find_leds
p leds
