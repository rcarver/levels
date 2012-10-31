require 'helper'

describe "acceptance: read ruby" do

  describe "types" do

    let(:ruby) {
      <<-RUBY
set :types,
    string: "hello",
    integer: 123,
    float: 1.5,
    boolean_true: true,
    boolean_false: false,
    array_of_string: ["a", "b", "c"],
    array_of_integer: [1, 2, 3],
    null: nil
set :group2,
    message: "hello world"
      RUBY
    }

    subject { Levels.read_ruby("the ruby", ruby, "file.rb") }

    assert_sample_data_set
  end

  describe "computed values" do

    let(:level1_ruby) {
      <<-RUBY
set :names,
    full_name: -> { [names.first_name, names.last_name].join(" ") },
    first_name: "John",
    last_name: "Doe"
      RUBY
    }

    let(:level2_ruby) {
      <<-RUBY
set :names,
    last_name: "Smith"
      RUBY
    }

    let(:level1) { Levels.read_ruby("the ruby", level1_ruby, "file.rb") }
    let(:level2) { Levels.read_ruby("the ruby", level2_ruby, "file.rb") }

    subject { Levels.merge(level1, level2) }

    it "resolves the computed value" do
      subject.names.full_name.must_equal "John Smith"
    end
  end
end
