class AcceptanceSpec < MiniTest::Spec

  register_spec_type(self) do |desc|
    desc =~ /^acceptance:/
  end

  def self.let_standard_level(name = :level)
    let(name) {
      level = Config::Env::Level.new("standard level")
      level.set_group(:types,
        string: "hello",
        integer: 123,
        float: 1.5,
        boolean_true: true,
        boolean_false: false,
        array_of_string: ["a", "b", "c"],
        array_of_integer: [1, 2, 3],
        null: nil
      )
      level.set_group(:group2,
        message: "hello world"
      )
      level
    }
  end

  def self.assert_sample_data_set

    it "parses string" do
      subject.types.string.must_equal "hello"
    end

    it "parses integer" do
      subject.types.integer.must_equal 123
    end

    it "parses float" do
      subject.types.float.must_equal 1.5
    end

    it "parses boolean" do
      subject.types.boolean_true.must_equal true
      subject.types.boolean_false.must_equal false
    end

    it "parses array" do
      subject.types.array_of_string.must_equal ["a", "b", "c"]
      subject.types.array_of_integer.must_equal [1, 2, 3]
    end

    it "parses null" do
      subject.types.null.must_equal nil
    end

    it "parses all groups" do
      subject.group2.message.must_equal "hello world"
    end
  end
end
