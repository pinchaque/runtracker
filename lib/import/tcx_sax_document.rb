# SAX document state machine for parsing TCX files with Nokogiri
# All parsed data is put into 'activity' 
class Import::TcxSAXDocument < Nokogiri::XML::SAX::Document
  public

  attr_reader :activity

  def initialize
    @activity = nil
    @lap = nil
    @point = nil
  end

  def end_document
    puts "the document has ended"
  end
  
  def start_element(name, attributes = [])
    puts "#{name} started"

    # reset to get ready for procesing text
    @last_tag = name

    case name
      when 'Activity'
      when 'Id'
      when 'Lap'
      when 'Trackpoint'
        @point = ActivityPoint.new

      when 'Time'
      when 'LatitudeDegrees'
      when 'LongitudeDegrees'
      when 'AltitudeMeters'
    end
  end

  def end_element(name)
    case name
      when 'Activity'

      when 'Id'
      when 'Lap'

      when 'Trackpoint'
        require_point
        @activity << @point
        @point = nil

      ### Data for ActivityPoint ###
      when 'Time'
        require_point
        @point.time = extract_date
      when 'LatitudeDegrees'
        require_point
        @point.latitude = extract_float
      when 'LongitudeDegrees'
        require_point
        @point.longitude = extract_float
      when 'AltitudeMeters'
        require_point
        @point.elevation = extract_float
    end
    
    # reset
    @str_buffer = ''
    @last_tag = nil
  end

  def characters(str)
    # ignore whitespace
    str.strip!
    return if str.empty?

    @str_buffer .= str
  end

  def error(str)
  end

  def warning(str)
  end

  def activity
    nil
  end

  private
  @activity
  @lap
  @point
  @last_tag
  @str_buffer
    

  # extracts a Float object from @str_buffer
  def extract_float
    Float(@str_buffer.strip)
  end

  # extracts a Time object from @str_buffer
  # expected format for TCX files: 2013-03-08T00:39:36.000Z
  def extract_date
    if (/(?<year>\d\d\d\d)-(?<month>\d\d)-(?<day>\d\d)T(?<hour>\d\d):(?<min>\d\d):(?<sec>\d\d\.?\d*)Z/ =~ extract_string(node, path))
      Time.new(year.to_i, month.to_i, day.to_i, hour.to_i, min.to_i, sec.to_f, '-00:00')
    else
      nil
    end
  end



###############################33

  def foo
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
    point.latitude = extract_float(node, '//Trackpoint/Position/LatitudeDegrees')
    #point.longitude = extract_float(node, '//Trackpoint/Position/LongitudeDegrees')
    #point.elevation = extract_float(node, '//Trackpoint/AltitudeMeters')
    point
  end
  def parse_type(type_str)
    case type_str
    when /^run/i then ActivityType::RUN
    when /^bike/i then ActivityType::CYCLE
    when /^cycle/i then ActivityType::CYCLE
    when /^bicycle/i then ActivityType::CYCLE
    else ActivityType::UNKNOWN
    end
  end

  def extract_string(node, path)
    node.xpath(path).inner_text.strip
  end

  # returns first numeric value matching node/path
  def extract_float(node, path)
    f = nil
    node.xpath(path).each do |n|
      begin
        f = Float(n.inner_text.strip)
        puts "xxx2[" + f.to_s + "]"
      rescue
        # ignore
      end
    end
    puts "xxx1[" + f.to_s + "]"
    return f
  end
end
