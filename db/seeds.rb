# Creates static or controlled value tables in the DB
Seed::FixedValue.new(ActivityType).seed(
  {
    ActivityType::RUN => 'Run',
    ActivityType::CYCLE => 'Cycle',
  });
