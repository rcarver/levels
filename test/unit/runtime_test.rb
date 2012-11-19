require 'helper'

describe Levels::Runtime do
  
  let(:klass) { 
    Class.new do
      include Levels::Runtime
    end
  }

  subject { klass.new }

  describe "#file" do

    it "reads a file" do

    end

  end
end
