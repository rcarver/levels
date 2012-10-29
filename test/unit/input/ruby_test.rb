require 'helper'

describe Levels::Input::Ruby do

  let(:level) { Levels::Level.new("Ruby") }

  subject { Levels::Input::Ruby.new(ruby_string, "file.rb", 1) }

  describe "successfully" do

    let(:ruby_string) {
      <<-RUBY
set :foo,
  value: "ok"
      RUBY
    }

    it "populates the level" do
      subject.read(level)
      level.eql_hash?(
        foo: {
          value: "ok"
        }
      ).must_equal true
    end
  end

  describe "with an error" do

    let(:ruby_string) {
      <<-RUBY
xset :foo,
  value: "ok"
      RUBY
    }

    it "provides useful information" do
      begin
        subject.read(level)
      rescue => e
        e.class.must_equal NoMethodError
        e.message.must_equal %(undefined method `xset' for <Levels>:Levels::Input::Ruby::DSL)
        e.backtrace.first.must_equal "file.rb:1:in `read'"
      end
    end
  end
end

