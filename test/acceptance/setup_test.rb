require 'helper'

describe "acceptance: the Setup" do

  subject { Levels::Setup.new }

  describe "reading various inputs" do

    let(:ruby_code) do
      <<-RUBY
group :group
  set a: 1
      RUBY
    end

    let(:json_code) do
      <<-JSON
{
  "group": {
    "a": 1
  }
}
      JSON
    end

    let(:yaml_code) do
      <<-YAML
---
group:
  a: 1
      YAML
    end

    it "adds a custom source" do
      custom_input = Class.new do
        def read(level)
          level.set_group(:group, a: 1)
        end
      end
      custom = custom_input.new
      subject.add("custom", custom)
      subject.merge.group.a.must_equal 1
    end

    it "adds ruby code" do
      subject.add("code", ruby_code)
      subject.merge.group.a.must_equal 1
    end

    it "adds JSON code" do
      subject.add("code", json_code)
      subject.merge.group.a.must_equal 1
    end

    it "adds YAML code" do
      subject.add("code", yaml_code)
      subject.merge.group.a.must_equal 1
    end

    it "adds a ruby file" do
      file = w("input.rb", ruby_code)
      subject.add("file", file.to_s)
      subject.merge.group.a.must_equal 1
    end

    it "adds a JSON file" do
      file = w("input.json", json_code)
      subject.add("file", file.to_s)
      subject.merge.group.a.must_equal 1
    end

    it "adds a YAML file (.yml)" do
      file = w("input.yml", yaml_code)
      subject.add("file", file.to_s)
      subject.merge.group.a.must_equal 1
    end

    it "adds a YAML file (.yaml)" do
      file = w("input.yaml", yaml_code)
      subject.add("file", file.to_s)
      subject.merge.group.a.must_equal 1
    end

    it "adds system variables" do
      begin
        subject.add "code", '{ "group": { "a": 0 } }'
        subject.add_system
        ENV['GROUP_A'] = '1'
        subject.merge.group.a.must_equal 1
      ensure
        ENV.delete('GROUP_A')
      end
    end

    it "adds system variables with a prefix" do
      begin
        subject.add "code", '{ "group": { "a": 0 } }'
        subject.add_system 'PFX_'
        ENV['PFX_GROUP_A'] = '1'
        subject.merge.group.a.must_equal 1
      ensure
        ENV.delete('PFX_GROUP_A')
      end
    end
  end
end
