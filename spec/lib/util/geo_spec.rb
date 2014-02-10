require 'spec_helper'

describe Geo do
  it "distance" do
    d = distance(36.12, -86.67, 33.94, -118.4)
    expect(d).to be_within(0.0000001).of(2886.4)
  end
end
