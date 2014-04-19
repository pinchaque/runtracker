# Performing geographic manipulations and computations
module Util::Geo
  # returns distance in miles between two points on earth 
  # using haversine formula
  # reference: http://www.movable-type.co.uk/scripts/latlong.html
  def distance(lat1, long1, lat2, long2)  
    r_earth = 3963.19 # miles
    
    # convert to radians
    rlat1, rlong1, rlat2, rlong2 = [lat1, long1, lat2, long2].map { |d| 
      d * Math::PI/180
    }

    # deltas
    dlat = rlat2 - rlat1
    dlon = rlong2 - rlong1

    a = (Math::sin(dlat/2.0)**2) + (Math::cos(rlat1) *  Math::cos(rlat2) * Math::sin(dlon/2.0)**2)
    c = 2 * Math::asin(Math::sqrt(a))

    r_earth * c
  end
  
  module_function :distance
end
