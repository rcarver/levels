class BaseSpec < MiniTest::Spec

  register_spec_type(self) { true }

  # Verify that when an Input is read into a Level,
  # that the Level matches the given Hash.
  def assert_input_equals_hash(hash)
    level = Levels::Level.new("Test")
    subject.read(level)
    level.eql_hash?(hash).must_equal true
  end

end

