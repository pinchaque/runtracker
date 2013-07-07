class ActivityLap < ActiveRecord::Base
  attr_accessible :start_time
  belongs_to :activity
  has_many :activity_points

  def points
    activity_points
  end
end
