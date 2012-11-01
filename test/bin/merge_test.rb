require 'helper'

describe "bin: merge" do

  let(:ruby_syntax) do
    <<-STR
set :sample,
    message: "hello"
    STR
  end

  let(:ruby_syntax_more) do
    <<-STR
set :more,
    number: 123
    STR
  end

  let(:json_syntax) do
    <<-STR
{
  "sample": {
    "message": "hello"
  }
}
    STR
  end

  let(:system_syntax) do
    <<-STR
export SAMPLE_MESSAGE="hello"
export SAMPLE_MESSAGE_TYPE="string"
    STR
  end

  let(:system_syntax_with_prefix) do
    <<-STR
export FOO_SAMPLE_MESSAGE="hello"
export FOO_SAMPLE_MESSAGE_TYPE="string"
    STR
  end

  let(:merged_json_syntax) do
    <<-STR
{
  "sample": {
    "message": "goodbye"
  }
}
    STR
  end

  let(:merged_system_keys) do
    {
      "SAMPLE_MESSAGE" => "goodbye",
      "SAMPLE_MESSAGE_TYPE" => "string"
    }
  end

  let(:merged_system_keys_with_prefix) do
    {
      "FOO_SAMPLE_MESSAGE" => "goodbye",
      "FOO_SAMPLE_MESSAGE_TYPE" => "string"
    }
  end

  describe "reading files" do

    it "reads a ruby file" do
      w("one.rb", ruby_syntax)
      assert_success "levels #{f 'one.rb'}"
      stdout.must_equal json_syntax
    end

    it "reads a json file" do
      w("one.json", json_syntax)
      assert_success "levels #{f 'one.json'}"
      stdout.must_equal json_syntax
    end

    it "merges files" do
      w("one.rb", ruby_syntax)
      w("one.json", merged_json_syntax)
      assert_success "levels #{f 'one.rb'} #{f 'one.json'}"
      stdout.must_equal merged_json_syntax
    end
  end

  describe "reading the system" do

    it "merges with the base" do
      w("one.rb", ruby_syntax)
      set_env merged_system_keys
      assert_success "levels --system #{f 'one.rb'}"
      stdout.must_equal merged_json_syntax
    end

    it "merges with the base with a prefix" do
      w("one.rb", ruby_syntax)
      set_env merged_system_keys_with_prefix
      assert_success "levels --system FOO_ #{f 'one.rb'}"
      stdout.must_equal merged_json_syntax
    end
  end

  describe "writing output" do

    it "writes json" do
      w("one.rb", ruby_syntax)
      assert_success "levels --output json #{f 'one.rb'}"
      stdout.must_equal json_syntax
    end

    it "writes system" do
      w("one.rb", ruby_syntax)
      assert_success "levels --output system #{f 'one.rb'}"
      stdout.must_equal system_syntax
    end

    it "writes system with a prefix" do
      w("one.rb", ruby_syntax)
      assert_success "levels --output system --prefix FOO_ #{f 'one.rb'}"
      stdout.must_equal system_syntax_with_prefix
    end
  end

  describe "logging" do

    it "logs each file read" do
      w("one.rb", ruby_syntax)
      w("one.json", json_syntax)
      assert_success "levels --no-output #{f 'one.rb'} #{f 'one.json'}"
      stderr.must_equal <<-STR
Add level "one.rb" from one.rb
Add level "one.json" from one.json
      STR
      stdout.must_equal ""
    end

    it "logs when the files are given level names" do
      w("one.rb", ruby_syntax)
      w("two.rb", ruby_syntax)
      w("one.json", json_syntax)
      w("three.rb", ruby_syntax)
      assert_success "levels --no-output --level 'RB one' --level --level 'JSON one' #{f 'one.rb'} #{f 'two.rb'} #{f 'one.json'} #{f 'three.rb'}"
      stderr.must_equal <<-STR
Add level "RB one" from one.rb
Add level "two.rb" from two.rb
Add level "JSON one" from one.json
Add level "three.rb" from three.rb
      STR
      stdout.must_equal ""
    end

    it "logs when the system is used" do
      w("one.rb", ruby_syntax)
      assert_success "levels --no-output --system --level 'First Level' #{f 'one.rb'}"
      stderr.must_equal <<-STR
Add level "First Level" from one.rb
Add level "System Environment"
      STR
      stdout.must_equal ""
    end

    it "logs when levels are merged" do
      w("one.rb", ruby_syntax)
      w("two.rb", ruby_syntax_more)
      set_env merged_system_keys
      assert_success "levels --system --level 'First Level' --level 'Second Level' #{f 'one.rb'} #{f 'two.rb'}"
      stderr.must_equal <<-STR
Add level "First Level" from one.rb
Add level "Second Level" from two.rb
Add level "System Environment"
Read sample.message
  Skip "hello" from First Level
  Use  "goodbye" from System Environment
Read more.number
  Use  123 from Second Level
      STR
      stdout.must_equal <<-STR
{
  "sample": {
    "message": "goodbye"
  },
  "more": {
    "number": 123
  }
}
      STR
    end
  end
end
