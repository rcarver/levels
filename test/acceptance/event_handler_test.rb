require 'helper'

describe "acceptance: the cli event handler" do

  def read_ruby(level_name, ruby_string)
    level = Levels::Level.new(level_name)
    input = Levels::Input::Ruby.new(ruby_string)
    input.read(level)
    level
  end

  it "handles lazy evaluation" do

    level1 = read_ruby("One", <<-RUBY)
group :names
  set full_name: -> { [names.first_name, names.last_name].join(" ") }
  set first_name: "John"
  set last_name: "Doe"
    RUBY

    level2 = read_ruby("Two", <<-RUBY)
group :names
  set last_name: "Smith"
    RUBY

    stream = StringIO.new

    configuration = Levels::Configuration.new([level1, level2])
    configuration.event_handler = Levels::CliEventHandler.new(stream)

    configuration.names.full_name

    stream.string.must_equal <<-STR
> names.full_name
  > names.first_name
   + "John" from One
  > names.last_name
   - "Doe" from One
   + "Smith" from Two
 + "John Smith" from One
    STR
  end
end
