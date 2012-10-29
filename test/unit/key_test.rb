require 'helper'

describe Levels::Key do

  let(:input) { "settings" }

  subject { Levels::Key.new(input) }

  specify "#to_sym" do
    subject.to_sym.must_equal :settings
  end

  specify "#inspect" do
    subject.inspect.must_equal "<Levels::Key :settings>"
  end

  specify "#to_s" do
    subject.to_s.must_equal subject.inspect
  end

  describe "comparisons" do

    let(:a) { Levels::Key.new(:a) }
    let(:b) { Levels::Key.new(:a) }
    let(:c) { Levels::Key.new(:b) }

    specify "equality" do
      (a == b).must_equal true
      (b == a).must_equal true
      (a == c).must_equal false
      (a == :a).must_equal false
    end

    specify "hashing" do
      hash = {}
      hash[a] = true
      hash[a].must_equal true
      hash[b].must_equal true
      hash[c].must_equal nil
      hash[:a].must_equal nil
    end
  end
end


