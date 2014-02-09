class Import::Generic < Nokogiri::XML::SAX::Document
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

  def print_node(node, depth = 0)
    prefix = "  " * depth
    if (node.name == 'text')
      puts prefix + "[TEXT]" + node.inner_text.strip + "[/TEXT]"
    else
      puts prefix + "[" + node.name + "]"
    end
    node.children.each do |cn|
      print_node(cn, depth + 1)
    end
  end
end
