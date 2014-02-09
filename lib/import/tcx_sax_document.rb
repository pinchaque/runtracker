# SAX document state machine for parsing TCX files with Nokogiri
# All parsed data is put into 'activity' 
class Import::TcxSAXDocument < Nokogiri::XML::SAX::Document
  public

  attr_reader :activity

  def initialize
    @activity = nil
    @lap = nil
    @point = nil
    @str_buffer = ''
  end

  def start_element(name, attributes = [])
   attr_hash = Hash[*attributes.flatten]

    case name
      when 'Activity'
        # only allow one activity per file
        require_activity(false)
        @activity = Activity.new
        @activity.activity_type_id = parse_type(attr_hash['Sport'])

      when 'Lap'
        require_activity
        require_lap(false)
        @lap = ActivityLap.new

      when 'Trackpoint'
        require_lap
        require_point(false)
        @point = ActivityPoint.new

      when 'Time'
        require_point

      when 'LatitudeDegrees'
        require_point

      when 'LongitudeDegrees'
        require_point

      when 'AltitudeMeters'
        require_point
    end
    
    # reset
    @str_buffer = ''
  end

  def end_element(name)
    case name
      when 'Activity'
        require_activity
        # compute start time based on all laps and points
        @activity.calculate_start_time!

      when 'Id'
        require_activity
        require_lap(false)
        @activity.uid = @activity.name = extract_string
      
      # End of Lap - save it to activity
      when 'Lap'
        require_lap

        # compute start time based on all points
        @lap.calculate_start_time!

        @activity.activity_laps << @lap
        @lap = nil

      # End of Trackpoint - save it to lap
      when 'Trackpoint'
        require_point
        if valid_point
          @lap.activity_points << @point
        end
        @point = nil

      # Data for ActivityPoint
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
  end

  def characters(str)
    # ignore whitespace
    str.strip!
    return if str.empty?

    @str_buffer << str
  end

  def error(str)
    raise ImportException, 'ERROR: ' + str
  end

  def warning(str)
    raise ImportException, 'WARNING: ' + str
  end

  private
  @activity
  @lap
  @point
  @str_buffer
      
      
  # ensures @activity is set iff v
  def require_activity(v = true)
    raise ImportException, "Expected open activity" if @activity.nil? == v
  end

  # ensures @lap is set iff v
  def require_lap(v = true)
    raise ImportException, "Expected open lap" if @lap.nil? == v
  end

  # ensures @point is set iff v
  def require_point(v = true)
    raise ImportException, "Expected open point" if @point.nil? == v
  end
    

  # extracts a Float object from @str_buffer
  def extract_float
    Float(extract_string)
  end

  # extracts a Time object from @str_buffer
  # expected format for TCX files: 2013-03-08T00:39:36.000Z
  def extract_date
    if (/(?<year>\d\d\d\d)-(?<month>\d\d)-(?<day>\d\d)T(?<hour>\d\d):(?<min>\d\d):(?<sec>\d\d\.?\d*)Z/ =~ extract_string)
      Time.new(year.to_i, month.to_i, day.to_i, hour.to_i, min.to_i, sec.to_f, '-00:00')
    else
      nil
    end
  end

  def extract_string
    @str_buffer.strip
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

  # returns true if the point contains enough data to be worth keeping
  def valid_point
    not (@point.time.nil? or @point.latitude.nil? or @point.longitude.nil?)
  end
end
