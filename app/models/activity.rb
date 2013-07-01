class Activity < ActiveRecord::Base
  attr_accessible :name, :start_time
  belongs_to :athlete, :activity_type
  has_many :activity_laps
end
