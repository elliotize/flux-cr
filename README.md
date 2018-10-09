# fluxcr

This is a 
## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  fluxcr:
    github: [your-github-name]/fluxcr
```

## Usage

```crystal
require "fluxcr"
finder = Fluxcr::LedFinder.new
leds = finder.all_leds
leds.get_statuses do |led, status|
  puts status.state
end

leds.turn_all_off

leds.turn_all_on
leds.turn_all_off
```

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/[your-github-name]/fluxcr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[your-github-name]](https://github.com/[your-github-name])  - creator, maintainer
