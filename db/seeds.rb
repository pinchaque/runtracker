# Creates static or controlled value tables in the DB

###########################################################################
# CLEAR TABLES
###########################################################################
[
  ActivityType,
].each do |o|
  puts("Clearing #{o}")
  o.delete_all
end

###########################################################################
# FIXED VALUE TABLES
###########################################################################
puts('Filling ActivityType');
[
  { :id => ActivityType::RUN, :name => 'Run'},
  { :id => ActivityType::CYCLE, :name => 'Cycle'},
].each do |d|
  puts("  #{d[:id]} => #{d[:name]}")
  FactoryGirl.create(:activity_type, :id => d[:id], :name => d[:name])
end
