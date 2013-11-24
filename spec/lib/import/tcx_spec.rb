require 'spec_helper'

def expect_point(point, time, lat, long, elev)
  expect(point.time).to eq(time)
  expect(point.latitude).to be_within(0.00001).of(lat)
  expect(point.longitude).to be_within(0.00001).of(long)
  expect(point.elevation).to be_within(0.00001).of(elev)
  expect(point.accuracy).to be_nil
  expect(point.temperature).to be_nil
  expect(point.heart_rate).to be_nil
end

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

      lap = activity.activity_laps[0]
      expect_point(
        lap.activity_points[0],
        Time.new(2013, 3, 8, 0, 39, 36, '-00:00'),
        32.71987985819578,
        -117.16575555503368,
        13.0)
      expect_point(
        lap.activity_points[1],
        Time.new(2013, 3, 8, 0, 39, 42, '-00:00'),
        32.71971607580781,
        -117.16573485173285,
        13.399999618530273)
      expect_point(
        lap.activity_points[2],
        Time.new(2013, 3, 8, 0, 39, 46, '-00:00'),
        32.71958456374705,
        -117.1657460834831,
        14.0)
      expect_point(
        lap.activity_points[3],
        Time.new(2013, 3, 8, 0, 39, 50, '-00:00'),
        32.71947526372969,
        -117.16576443985105,
        15.399999618530273)
    end
  end
end
