require 'spec_helper'

describe Import::Tcx do
fn = File.expand_path('../../../../test/data/simple_01.tcx', __FILE__)
  it "#{fn} parses" do
    File.open(fn) do |f|
      activity = Import::Tcx.new.parse(f)
      activity.activity_type_id.should eq(ActivityType::RUN)
      activity.uid.should eq('XYZ Activity Name')
      activity.name.should eq('XYZ Activity Name')
      activity.start_time.should eq(Time.new(2013, 3, 8, 0, 39, 36, '-00:00'))
      activity.activity_laps.size.should eq(1)
      activity.activity_laps[0].activity_points.size.should eq(4)

      p0 = activity.activity_laps[0].activity_points[0]
      expect(p0.time).to eq(Time.new(2013, 3, 8, 0, 39, 36, '-00:00'))
      expect(p0.latitude).to be_within(0.00001).of(32.71987985819578)
      expect(p0.longitude).to be_within(0.00001).of(-117.16575555503368)
      expect(p0.elevation).to be_within(0.00001).of(13.0)
      expect(p0.accuracy).to be_nil
      expect(p0.temperature).to be_nil
      expect(p0.heart_rate).to be_nil
    end
  end
end
