require 'helper'

describe Config::Env do

  specify ".new" do
    Config::Env.new.must_be_instance_of Config::Env::Level
  end

  specify ".merge" do
    Config::Env.merge([]).must_be_instance_of Config::Env::Merged
  end
end

