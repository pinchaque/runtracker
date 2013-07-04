class FixedValueSeed
  def initialize(klass, fstream = STDERR)
    @klass = klass
    @class_name = klass.name
    @class_label = klass.name.underscore.to_sym
    @fstream = fstream
  end

  def clear
    @fstream.puts("Seeding #{@class_name}")
    @klass.delete_all
  end

  def add_values(map)
    map.each do |k, v|
      @fstream.puts("  #{k} => #{v}")
      FactoryGirl.create(@class_label, :id => k, :name => v)
    end
  end

  def seed(map)
    clear
    add_values(map)
  end
end
