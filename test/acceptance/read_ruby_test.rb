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
end
