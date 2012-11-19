require 'helper'
require 'tempfile'

describe Levels::Runtime do
  
  let(:klass) { 
    Class.new do
      include Levels::Runtime
    end
  }

  subject { klass.new }

  describe "#file" do

    # NOTE: This test uses an absolute path. The test
    # for relative path interpretation is in
    # acceptance/read_ruby_test.rb
    it "returns a proc that reads a file" do
      f = Tempfile.new("f")
      begin
        f.print "hello"
        f.close
        proc = subject.file(f.path)
        proc.call.must_equal "hello"
      ensure
        f.close!
      end
    end

    it "raises an error from the proc when given a path that doesn't exist" do
      proc = subject.file("/no/file/here")
      -> { proc.call }.must_raise(Levels::Runtime::FileNotFoundError)
    end

    it "returns nil if given nil" do
      subject.file(nil).must_equal nil
    end
  end
end
