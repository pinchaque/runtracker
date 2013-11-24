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
    end
  end
end
