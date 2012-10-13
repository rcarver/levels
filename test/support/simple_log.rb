class SimpleLog

  def initialize(stream)
    @stream = stream
  end

  def <<(input)
    @stream.puts input
  end

  def colorize(input, color)
    self << input
  end
end

