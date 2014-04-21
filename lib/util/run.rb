# Performing calculations related to running
module Util::Run
  # Calculates a normalized speed over 1 mile given the specified speed over
  # the specified distance. All speeds specified in MPH.
  # Reference: http://www.runningforfitness.org/faq/rp
  def normalize_speed(speed, distance)
    convert_speed(speed, distance, 1.0)
  end
  
  # Converts speed at one distance to equivalent speed at another distance
  # speed1: Known speed (MPH)
  # distance1: Known distance (MI)
  # distance2: Distance at which you want to calculate equivalent speed (MI)
  # Reference: http://www.runningforfitness.org/faq/rp
  def convert_speed(speed1, distance1, distance2)
    speed1 * (distance2 ** 0.06) * (distance1 ** 0.06)
  end


  # Returns projected time to run dist2 based on known time1 that it took
  # to run dist1
  # Reference: http://www.runningforfitness.org/faq/rp
  def projected_time(time1, dist1, dist2)
    time1 * ((dist2 / dist1) ** 1.06)
  end
  
  module_function :projected_time
  module_function :normalize_speed
  module_function :convert_speed
end
