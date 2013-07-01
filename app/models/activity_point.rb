class ActivityPoint < ActiveRecord::Base
  attr_accessible :time, :latitude, :longitude, :elevation, :accuracy, :temperature, :heart_rate
  belongs_to :activity_lap
end
