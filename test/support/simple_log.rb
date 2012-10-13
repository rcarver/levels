class SimpleLog

  def initialize(stream)
    @stream = stream
    @indent_level = 0
    @indent_string = " " * 2
  end

  def log
    self
  end

  def <<(input)
    input.to_s.split("\n").each do |line|
      @stream.puts "#{current_indent}#{line}"
    end
  end

  def colorize(input, color)
    input
  end

  def indent(level=1)
    @indent_level += level
    begin
      yield
    ensure
      @indent_level -= level
    end
  end

protected

  def current_indent
    @indent_string * @indent_level
  end
end

