require 'helper'
require 'tempfile'

describe "acceptance: read ruby" do

  def read_ruby(level_name, ruby_string)
    level = Levels::Level.new(level_name)
    input = Levels::Input::Ruby.new(ruby_string)
    input.read(level)
    level
  end

  describe "types" do

    let(:ruby) {
      <<-RUBY
group "types"
  set string: "hello"
  set integer: 123
  set float: 1.5
  set boolean_true: true
  set boolean_false: false
  set array_of_string: ["a", "b", "c"]
  set array_of_integer: [1, 2, 3]
  set null: nil

group "group2"
  set message: "hello world"
      RUBY
    }

    subject { read_ruby("test", ruby) }

    assert_sample_data_set
  end

  describe "computed values" do

    let(:level1_ruby) {
      <<-RUBY
group :names
  set full_name: -> { [names.first_name, names.last_name].join(" ") }
  set first_name: "John"
  set last_name: "Doe"
      RUBY
    }

    let(:level2_ruby) {
      <<-RUBY
group "names"
  set last_name: "Smith"
      RUBY
    }

    let(:level1) { read_ruby("ruby level 1", level1_ruby) }
    let(:level2) { read_ruby("ruby level 2", level2_ruby) }

    subject { Levels::Configuration.new([level1, level2]) }

    it "resolves the computed value" do
      subject.names.full_name.must_equal "John Smith"
    end
  end

  describe "reading a file" do

    let(:ruby_file) { f("file.rb") }

    def read_ruby_with_file_path_path(path)
      input = Levels::Input::Ruby.new(<<-RUBY, ruby_file.to_s)
group "group1"
  set message: file("#{path}")
  set lazy_message: -> { file("#{path}") }
      RUBY
      level = Levels::Level.new("test")
      input.read(level)
      Levels::Configuration.new([level])
    end

    it "reads a file in the same directory" do
      level = read_ruby_with_file_path_path("f1")
      w("f1", "hello world")
      level.group1.message.must_equal "hello world"
    end

    it "reads a file at a relative path" do
      level = read_ruby_with_file_path_path("d/f1")
      (ruby_file.dirname + "d").mkdir
      w("d/f1", "hello world")
      level.group1.message.must_equal "hello world"
    end

    it "reads a file at an absolute path" do
      f = Tempfile.new("f")
      begin
        level = read_ruby_with_file_path_path(f.path)
        f.write "hello world"
        f.close
        level.group1.message.must_equal "hello world"
      ensure
        f.close!
      end
    end

    it "fails if the file does not exist" do
      level = read_ruby_with_file_path_path("f1")
      level.group1.defined?(:message).must_equal true
      -> { level.group1.message }.must_raise Levels::Runtime::FileNotFoundError
    end

    it "lazily reads a file" do
      level = read_ruby_with_file_path_path("f1")
      w("f1", "hello world")
      level.group1.lazy_message.must_equal "hello world"
    end
  end
end
