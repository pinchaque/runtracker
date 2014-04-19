require 'spec_helper'

describe Util::Geo do
  it "distance" do
    d = Util::Geo::distance(36.12, -86.67, 33.94, -118.4)
    expect(d).to be_within(0.1).of(1795.5624)

    d = Util::Geo::distance(36.12, 40.0, 33.94, 44.0)
    expect(d).to be_within(0.1).of(272.115)
  end
end
