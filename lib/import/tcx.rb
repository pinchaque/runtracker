module Import::Tcx
  def parse(io)
    tsd = Import::TcxSAXDocument.new
    parser = Nokogiri::XML::SAX::Parser.new(tsd)
    parser.parse(io)
    tsd.activity
  end
  module_function :parse
end
