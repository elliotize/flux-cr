require "./spec_helper"
require "socket"

describe Fluxcr::LedFinder do
  let(:socket) { 0 }
  subject { Fluxcr::LedFinder.new(socket) }

  it "should find two leds" do
    subject.find_leds
  end
end
