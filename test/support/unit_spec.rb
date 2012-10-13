class UnitSpec < MiniTest::Spec

  register_spec_type(self) do |desc|
    true
  end

  def log_string
    log_stream.string
  end

  let(:log_stream) { StringIO.new }

  before do
    Config::Env::Loggable.impl = SimpleLog.new(log_stream)
  end
end

