require 'helper'

describe "acceptance: read ruby" do

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

    subject { Levels.read_ruby("the ruby", ruby, "file.rb") }

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

    let(:level1) { Levels.read_ruby("the ruby", level1_ruby, "file.rb") }
    let(:level2) { Levels.read_ruby("the ruby", level2_ruby, "file.rb") }

    subject { Levels.merge(level1, level2) }

    it "resolves the computed value" do
      subject.names.full_name.must_equal "John Smith"
    end
  end
end
