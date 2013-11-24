class Import::Tcx < Import::Generic
  public
  def parse(io)
    # read in the XML
    doc = Nokogiri::XML::parse(io)
    doc.remove_namespaces!

    # parse one and only one activity
    activity = nil
    node = doc.xpath('//Activities/Activity')
    if node.count == 1
      activity = parse_activity(node[0])
    elsif node.count > 1
      raise ImportException, "Only one <Activity> per file", caller
    else
      activity = Activity.new
    end
    activity
  end

  private
  # Handles <Activity> nodes within file
  def parse_activity(node)
    activity = Activity.new

    # <Activity Sport="Running">
    activity.activity_type_id = parse_type(node['Sport'])

    # <Id>XYZ Activity Name</Id>
    activity.uid = extract_string(node, '//Activity/Id')
    activity.name = activity.uid

    # <Lap StartTime="2013-03-08T00:39:36.000Z">
    node.xpath('//Activity/Lap').each do |lap_node|
      activity.activity_laps << parse_lap(lap_node)
    end

    # compute start time based on all laps and points
    activity.calculate_start_time!
  end

  # Handles <Lap> nodes within file
  def parse_lap(node)
    lap = ActivityLap.new

    # Now we process all trackpoints under <Track>
    node.xpath('//Lap/Track/Trackpoint').each do |point_node|
      lap.activity_points << parse_point(point_node)
    end
    
    # compute start time based on all points
    lap.calculate_start_time!
  end

  def parse_point(node)
    point = ActivityPoint.new
    print_node(node)
    point.time = extract_date(node, '//Trackpoint/Time')
    point.latitude = extract_float(node, '//Trackpoint/Position/LatitudeDegrees')
    point.longitude = extract_float(node, '//Trackpoint/Position/LongitudeDegrees')
    point.elevation = extract_float(node, '//Trackpoint/AltitudeMeters')
    point
  end

  # expected format for TCX files: 2013-03-08T00:39:36.000Z
  def extract_date(node, path)
    if (/(?<year>\d\d\d\d)-(?<month>\d\d)-(?<day>\d\d)T(?<hour>\d\d):(?<min>\d\d):(?<sec>\d\d\.?\d*)Z/ =~ extract_string(node, path))
      Time.new(year.to_i, month.to_i, day.to_i, hour.to_i, min.to_i, sec.to_f, '-00:00')
    else
      nil
    end
  end
end
