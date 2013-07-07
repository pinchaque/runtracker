class ActivityType < ActiveRecord::Base
  attr_accessible :name
  RUN = 1
  CYCLE = 2
  UNKNOWN = 3
end
