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
end
