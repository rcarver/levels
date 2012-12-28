require 'helper'

describe Levels do

  specify ".setup" do
    Levels.setup.must_be_instance_of Levels::Setup
  end

  specify ".merge" do
    Levels.merge.must_be_instance_of Levels::Merged
  end

  specify ".merge with a block" do
    block_called = false
    merged = Levels.merge do |setup|
      block_called = true
      setup.must_be_instance_of Levels::Setup
    end
    block_called.must_equal true
    merged.must_be_instance_of Levels::Merged
  end
end

