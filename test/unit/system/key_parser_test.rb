require 'helper'

describe Config::Env::System::KeyParser do

  subject { Config::Env::System::KeyParser.new }

  describe "basic parsing rules" do

    it "returns nil if the value is empty" do
      env = {
        "K" => ""
      }
      value = subject.parse(env, "K", "template is string")
      value.must_equal nil
    end

    it "returns a value based on typecast info if the template value is nil" do
      env = {
        "K" => "123",
        "K_TYPE" => "integer"
      }
      value = subject.parse(env, "K", nil)
      value.must_equal 123
    end

    it "returns a value based on the template if no typecast info is available" do
      env = {
        "K" => "123"
      }
      value = subject.parse(env, "K", 999)
      value.must_equal 123
    end

    it "returns a value based on typecast info if both template and typecast info exist" do
      env = {
        "K" => "123",
        "K_TYPE" => "integer"
      }
      value = subject.parse(env, "K", "template is a string")
      value.must_equal 123
    end

    it "returns a string if neither typecast or template are available" do
      env = {
        "K" => "123"
      }
      value = subject.parse(env, "K", nil)
      value.must_equal "123"
    end
  end

  describe "parsing simple types" do

    describe "from typecast info" do

      specify "string" do
        env = {
          "K" => "hello",
          "K_TYPE" => "string"
        }
        subject.parse(env, "K", nil).must_equal "hello"
      end

      specify "integer" do
        env = {
          "K" => "123",
          "K_TYPE" => "integer"
        }
        subject.parse(env, "K", nil).must_equal 123
      end

      specify "float" do
        env = {
          "K" => "1.5",
          "K_TYPE" => "float"
        }
        subject.parse(env, "K", nil).must_equal 1.5
      end

      specify "boolean" do
        env = {
          "T" => "true",
          "T_TYPE" => "boolean",
          "O" => "1",
          "O_TYPE" => "boolean",
          "F" => "false",
          "F_TYPE" => "boolean",
          "X" => "blah",
          "X_TYPE" => "boolean"
        }
        subject.parse(env, "T", nil).must_equal true
        subject.parse(env, "O", nil).must_equal true
        subject.parse(env, "F", nil).must_equal false
        subject.parse(env, "X", nil).must_equal false
      end

      specify "an unknown type" do
        env = {
          "K" => "hello",
          "K_TYPE" => "other"
        }
        -> { subject.parse(env, "K", nil) }.must_raise(ArgumentError)
      end
    end

    describe "from the template value" do

      specify "string" do
        env = {
          "K" => "hello"
        }
        subject.parse(env, "K", "str").must_equal "hello"
      end

      specify "integer" do
        env = {
          "K" => "123"
        }
        subject.parse(env, "K", 999).must_equal 123
      end

      specify "float" do
        env = {
          "K" => "1.5"
        }
        subject.parse(env, "K", 1.0).must_equal 1.5
      end

      specify "boolean" do
        env = {
          "T" => "true",
          "O" => "1",
          "F" => "false",
          "X" => "blah"
        }
        subject.parse(env, "T", false).must_equal true
        subject.parse(env, "O", false).must_equal true
        subject.parse(env, "F", true).must_equal false
        subject.parse(env, "X", true).must_equal false
      end

      specify "an unknown type" do
        env = {
          "K" => "hello"
        }
        -> { subject.parse(env, "K", Object.new) }.must_raise(ArgumentError)
      end
    end
  end

  describe "parsing an array" do

    describe "from typecast info" do

      it "parses from the array" do
        env = {
          "K" => "a:b:c",
          "K_TYPE" => "array"
        }
        subject.parse(env, "K", nil).must_equal ["a", "b", "c"]
      end

      it "parses the array values" do
        env = {
          "K" => "1:2:3",
          "K_TYPE" => "array",
          "K_TYPE_TYPE" => "integer"
        }
        subject.parse(env, "K", nil).must_equal [1, 2, 3]
      end
    end

    describe "from the template value" do

      it "it parses the array" do
        env = {
          "K" => "a:b:c"
        }
        subject.parse(env, "K", []).must_equal ["a", "b", "c"]
      end

      it "parses the array values" do
        env = {
          "K" => "1:2:3"
        }
        subject.parse(env, "K", [1]).must_equal [1, 2, 3]
      end

      it "parses the array values from typecast info" do
        env = {
          "K" => "1:2:3",
          "K_TYPE_TYPE" => "integer"
        }
        subject.parse(env, "K", []).must_equal [1, 2, 3]
        subject.parse(env, "K", ["string"]).must_equal [1, 2, 3]
      end
    end

    it "uses another delimiter" do
      env = {
        "K" => "a,b,c",
        "K_DELIMITER" => ","
      }
      subject.parse(env, "K", []).must_equal ["a", "b", "c"]
    end
  end
end
