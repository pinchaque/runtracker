class ActivityLap < ActiveRecord::Base
  attr_accessible :start_time
  belongs_to :activity
  has_many :activity_points

  def calculate_start_time!
    self.start_time = calculate_start_time
    self
  end

  def calculate_start_time
    start = nil
    activity_points.each do |point|
      start = point.time if (start.nil? or (start < point.time))
    end
    start
  end
end
