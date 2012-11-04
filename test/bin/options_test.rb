require 'helper'

describe "bin: options" do

  describe "--[no-]color" do

    before do
      w("one.rb", <<-RUBY)
set :sample,
  message: "hello"
      RUBY
    end

    it "can be turned on" do
      assert_success "levels --color #{f 'one.rb'}"
      stderr.must_match(Levels::Colorizer::FOREGROUND[:green])
    end

    it "can be turned off" do
      assert_success "levels --no-color #{f 'one.rb'}"
      stderr.wont_match(Levels::Colorizer::FOREGROUND[:green])
    end
  end

  describe "--version" do

    it "works" do
      assert_success "levels --version"
      stdout.must_equal "Levels #{Levels::VERSION}\n"
    end
  end

  describe "--help" do

    it "works" do
      assert_success "levels --help"
      stdout.split("\n")[0].must_equal "Usage: levels [options] [files]"
    end
  end
end

