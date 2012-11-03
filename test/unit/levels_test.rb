require 'helper'

describe Levels do

  specify ".merge" do
    Levels.merge([]).must_be_instance_of Levels::Merged
  end
end

