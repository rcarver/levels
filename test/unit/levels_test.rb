require 'helper'

describe Levels do

  specify ".setup" do
    Levels.setup.must_be_instance_of Levels::Setup
  end

  specify ".merge" do
    Levels.merge.must_be_instance_of Levels::Configuration
  end

  specify ".merge with a block" do
    block_called = false
    configuration = Levels.merge do |setup|
      block_called = true
      setup.must_be_instance_of Levels::Setup
    end
    block_called.must_equal true
    configuration.must_be_instance_of Levels::Configuration
  end
end

