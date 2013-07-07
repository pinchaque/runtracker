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


def print_node(n, l)
  prefix = "  " * l
  puts prefix + "[" + n.name + "]"
  n.children.each do |cn|
    print_node(cn, l + 1)
  end
end


###########################################################################
# CREATE SAMPLE DATA
###########################################################################
athlete = FactoryGirl.create(:athlete)
puts("Created #{athlete.id}: #{athlete.name}")

Dir.glob(File.expand_path('../../test/data/*.tcx.gz', __FILE__)) do |fn|
  puts("Importing #{fn}")

  Zlib::GzipReader.open(fn) do |f|
    doc = Nokogiri::XML::parse(f)
    doc.remove_namespaces!
    doc.xpath('//Author').each do |node|
      print_node(node, 0)
    end
  end
  break
end
