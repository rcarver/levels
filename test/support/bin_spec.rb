require 'tmpdir'

class BinSpec < MiniTest::Spec
  include TempfileHelper

  register_spec_type(self) do |desc|
    desc =~ /^bin:/
  end

  Result = Struct.new(:stdout, :stderr, :status)

  def set_env(hash)
    @command_env = hash
  end

  def assert_success(command)
    args = [@command_env, command].compact
    stdout, stderr, status = Open3.capture3(*args)
    @result = Result.new(stdout, stderr, status.exitstatus)
    if @result.status != 0
      raise MiniTest::Assertion, "Status: #{@result.status}\n#{@result.stderr}"
    end
  end

  def stdout
    @result.stdout
  end

  def stderr
    @result.stderr
  end

  def status
    @result.status
  end

  # Create a temporary directory. This directory will exist for the life of
  # the spec.
  #
  # id - Identifier of the tmpdir (default: the default identifier).
  #
  # Returns a Pathname.
  def tmpdir(id=:default)
    @tmpdirs[id] ||= Pathname.new(Dir.mktmpdir).realdirpath
  end

  # Get a file within the tmpdir.
  def f(name)
    tmpdir + name
  end

  # Write a file within the tmpdir.
  def w(name, content)
    f(name).open("w") { |f| f.puts content }
  end

  before do
    @tmpdirs = {}
  end

  after do
    @tmpdirs.values.each { |dir| FileUtils.rm_rf dir.to_s }
  end

end
