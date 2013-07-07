class Import::Tcx < Import::Generic
  public
  def parse(io)
    # read in the XML
    doc = Nokogiri::XML::parse(io)
    doc.remove_namespaces!

    # parse one and only one activity
    node = doc.xpath('//Activities/Activity')
    if node.count == 1
      parse_activity(node[0])
    elsif node.count > 1
      raise ImportException, "Only one <Activity> per file", caller
    else
      Activity.new
    end
  end

  private
  # Handles <Activity> nodes within file
  def parse_activity(node)
    activity = Activity.new

    # <Activity Sport="Running">
    activity.activity_type_id = parse_type(node['Sport'])
    activity.name = 'foo'
    puts activity.name

    # <Id>XYZ Activity Name</Id>
    activity.uid = extract_string(node, '/Activity/Id')

    # <Lap StartTime="2013-03-08T00:39:36.000Z">
    node.xpath('/Activity/Lap').each do |lap_node|
      lap = parse_lap(lap_node)
      activity.laps << lap
    end

    # compute start time based on all laps and points
    activity.calculate_start_time
  end

  def parse_lap(node)
    lap = ActivityLap.new

    # Now we process all trackpoints under <Track>
    node.xpath('/Lap/Track/Trackpoint').each do |point_node|
      lap.points << parse_point(point_node)
    end

    lap.calculate_start_time
  end

  def parse_point(node)
    point = ActivityPoint.new
    point.time = extract_date(node, '/Trackpoint/Time')
    point.latitude = extract_float(node, '/Trackpoint/Position/LatitudeDegrees')
    point.longitude = extract_float(node, '/Trackpoint/Position/LongitudeDegrees')
    point.elevation = extract_float(node, '/Trackpoint/AltitudeMeters')
    point
  end

  def print_node(node, depth = 0)
    prefix = "  " * depth
    puts prefix + "[" + node.name + "]"
    node.children.each do |cn|
      print_node(cn, depth + 1)
    end
  end
end
