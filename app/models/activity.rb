class Activity < ActiveRecord::Base
  attr_accessible :name
  attr_accessible :start_time
  attr_accessible :uid
  belongs_to :athlete
  belongs_to :activity_type
  has_many :activity_laps

  def calculate_start_time!
    self.start_time = calculate_start_time
    self
  end

  def calculate_start_time
    start = nil
    activity_laps.each do |lap|
      lap_start = lap.calculate_start_time
      start = lap_start if (start.nil? or (start > lap_start))
    end
    start
  end
end
