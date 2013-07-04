# Creates static or controlled value tables in the DB
require File.expand_path('../../lib/seed/fixed_value_seed.rb', __FILE__)

FixedValueSeed.new(ActivityType).seed(
  {
    ActivityType::RUN => 'Run',
    ActivityType::CYCLE => 'Cycle',
  });
