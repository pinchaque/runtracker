require 'spec_helper'

describe Import::Tcx do
  it "contains the right data" do
    fn = File.expand_path('../../../../test/data/simple_01.tcx', __FILE__)
    File.open(fn) do |f|
      activity = Import::Tcx.new.parse(f)
      activity.activity_type_id.should eq(ActivityType::RUN)
      activity.uid.should eq('XYZ Activity Name')
      activity.name.should eq('XYZ Activity Name')
      #activity.start_time.should eq(ActivityType::RUN)
      activity.laps.count.should eq(1)
      activity.laps[0].points.count.should eq(4)
    end
  end
end
