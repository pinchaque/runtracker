class Import::Generic
  def parse(io)
  end

  protected
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

  def extract_float(node, path)
    extract_string(node, path).to_f
  end
end
