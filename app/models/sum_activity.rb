class SumActivity < ActiveRecord::Base
  attr_accessible :name
  attr_accessible :start_time
  attr_accessible :end_time
  attr_accessible :duration
  attr_accessible :distance
  attr_accessible :elevation_gain
  attr_accessible :elevation_loss
  belongs_to :athlete
  belongs_to :activity
  belongs_to :activity_type
  

  def SumActivity.create_from_activity(activity)
    sa = SumActivity.new

    # copy some fields directly over
    sa.activity_id = activity.id
    sa.athlete_id = activity.athlete_id
    sa.activity_type_id = activity.activity_type_id
    sa.name = activity.name
    sa.start_time = activity.start_time

    # initialize
    sa.distance = 0.0 # feet
    sa.elevation_gain = 0.0 # feet
    sa.elevation_loss = 0.0 # feet
    sa.end_time = nil
    sa.duration = 0
    max_time = last_lat = last_lng = last_elev = nil

    # iterate through all contained points to get remaining fields
    activity.activity_laps.each do |lap|
      lap.activity_points.each do |pt|

        # update end time
        sa.end_time = pt.time if (sa.end_time.nil? or (pt.time > sa.end_time))

        # update distance
        if not (last_lat.nil? or last_lng.nil?)
          sa.distance += Util::Geo::distance(
            last_lat, last_lng, 
            pt.latitude, pt.longitude)
        end

        # update elevation
        if not last_elev.nil?
          v = pt.elevation - last_elev
          if v > 0
              sa.elevation_gain += v
          else
              sa.elevation_loss += v
          end
        end

        # store values for next iteration
        last_lat = pt.latitude
        last_lng = pt.longitude
        last_elev = pt.elevation
      end
    end

    # finalize
    sa.duration = sa.end_time - sa.start_time unless sa.end_time.nil? or sa.start_time.nil?

    # return
    sa
  end
end
