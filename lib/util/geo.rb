# Performing geographic manipulations and computations
module Geo
  # returns distance between two points on earth using haversine formula
  # reference: http://www.movable-type.co.uk/scripts/latlong.html
  def distance(lat1, long1, lat2, long2)  
    r_earth = 6378.14 
    
    # convert to radians
    rlat1, rlong1, rlat2, rlong2 = [lat1, long1, lat2, long2].map begin |d| 
      d * Math::PI/180
    end

    # deltas
    dlon = rlong1 - rlong2
    dlat = rlat1 - rlat2

    a = (Math::sin(dlat/2) ** 2) 
      + Math::cos(rlat1) * Math::cos(rlat2) * (Math::sin(dlon/2) ** 2)

    r_earth * 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
  end
  
  module_function :distance
end
