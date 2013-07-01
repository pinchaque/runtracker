class ActivityLap < ActiveRecord::Base
  attr_accessible :start_time
  belongs_to :activity
  has_many :activity_points
end
