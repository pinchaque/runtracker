require 'spec_helper'

def gen_point(time, lat, long, elev)
  pt = ActivityPoint.new
  pt.time = time
  pt.latitude = lat
  pt.longitude = long
  pt.elevation = elev
  pt.accuracy = 0.0
  pt.temperature = 0.0
  pt.heart_rate = 130
  pt
end

describe SumActivity do
  it "summarize" do
  
    # basic activity info
    act = Activity.new
    act.id = -1
    act.athlete_id = -2
    act.name = "Activity 1"
    act.activity_type_id = ActivityType::CYCLE

    t1 = t2 = Time.new(2014, 3, 1, 10, 1, 1)

    # create all the data points for the activity
    lap = ActivityLap.new
    lap.activity_points << gen_point(t2, 36, -86, 100)
    t2 += 60
    lap.activity_points << gen_point(t2, 37, -87, 200)
    t2 += 60
    lap.activity_points << gen_point(t2, 38, -86, 150)
    t2 += 60
    lap.activity_points << gen_point(t2, 38, -87, 300)
    act.activity_laps << lap
    act.calculate_start_time!

    # create summary
    sa = SumActivity.create_from_activity(act)

    # validate
    expect(sa.name).to eq("Activity 1")
    expect(sa.activity_id).to eq(-1)
    expect(sa.activity_type_id).to eq(ActivityType::CYCLE)
    expect(sa.athlete_id).to eq(-2)
    expect(sa.start_time).to eq(t1)
    expect(sa.end_time).to eq(t2)
    expect(sa.duration).to eq(t2 - t1)
    expect(sa.distance).to be_within(0.1).of(231.548)
    expect(sa.elevation_gain).to be_within(0.1).of(250)
    expect(sa.elevation_loss).to be_within(0.1).of(-50)
  end
end
