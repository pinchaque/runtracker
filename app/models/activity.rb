class Activity < ActiveRecord::Base
  attr_accessible :name
  attr_accessible :start_time
  attr_accessible :uid
  belongs_to :athlete
  belongs_to :activity_type
  has_many :activity_laps

  def laps
    activity_laps
  end
end
