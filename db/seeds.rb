# Creates static or controlled value tables in the DB
Seed::FixedValue.new(ActivityType).seed(
  {
    ActivityType::RUN => 'Run',
    ActivityType::CYCLE => 'Cycle',
  });

###########################################################################
# CLEAR OUT OLD DATA
###########################################################################
[
  Activity,
  ActivityLap,
  ActivityPoint,
  Athlete,
].each do |o|
  puts("Clearing #{o}")
  o.delete_all
end

###########################################################################
# CREATE SAMPLE DATA
###########################################################################
athlete = FactoryGirl.create(:athlete)
puts("Created #{athlete.id}: #{athlete.name}")

Dir.glob(File.expand_path('../../test/data/*.tcx.gz', __FILE__)) do |fn|
  puts("Importing #{fn}")

  Zlib::GzipReader.open(fn) do |f|
    activity = Import::Tcx::parse(f)
    activity.athlete_id = athlete.id
    activity.save
  end
end
