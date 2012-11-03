require 'helper'

describe "acceptance: the cli event handler" do

  it "handles lazy evaluation" do

    level1 = Levels.read_ruby("One", <<-RUBY, "file.rb")
set :names,
    full_name: -> { [names.first_name, names.last_name].join(" ") },
    first_name: "John",
    last_name: "Doe"
    RUBY

    level2 = Levels.read_ruby("Two", <<-RUBY, "file.rb")
set :names,
    last_name: "Smith"
    RUBY

    stream = StringIO.new

    merged = Levels.merge(level1, level2)
    merged.event_handler = Levels::CliEventHandler.new(stream)

    merged.names.full_name

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
