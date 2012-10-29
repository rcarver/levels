require 'helper'

describe Levels do

  specify ".new" do
    Levels.new.must_be_instance_of Levels::Level
  end

  specify ".merge" do
    Levels.merge([]).must_be_instance_of Levels::Merged
  end
end

