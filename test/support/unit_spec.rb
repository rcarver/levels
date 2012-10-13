class UnitSpec < MiniTest::Spec

  register_spec_type(self) do |desc|
    true
  end

  def log_string
    log_stream.string
  end

  let(:log_stream) { StringIO.new }

  before do
    mod = Module.new do
      def self.log
        SimpleConfigLog.new(log_stream)
      end
    end
    Config::Env::Loggable.impl = mod
  end
end

