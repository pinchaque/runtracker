require 'spec_helper'

describe Util::Run do
  it "normalized pace" do
    d = Util::Run::normalize_speed(6.85, 10.0)
    expect(d).to be_within(0.1).of(7.87)

    d = Util::Run::normalize_speed(7.37, 3.2)
    expect(d).to be_within(0.1).of(7.90)

    d = Util::Run::normalize_speed(7.87, 6.0)
    expect(d).to be_within(0.1).of(8.76)

    d = Util::Run::normalize_speed(7.87, 1.0)
    expect(d).to be_within(0.1).of(7.87)
  end

  it "projected times" do
    d = Util::Run::projected_time(10.0, 1.0, 1.0)
    expect(d).to be_within(0.1).of(10.0)

    d = Util::Run::projected_time(0.115627, 1.0, 6.0)
    expect(d).to be_within(0.1).of(0.7725)

    d = Util::Run::projected_time(0.124130, 1.0, 8.0)
    expect(d).to be_within(0.1).of(1.125)
  end
end
