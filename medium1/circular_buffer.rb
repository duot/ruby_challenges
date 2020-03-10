require 'pry'

# implementation using Array splicing and assignment destructuring
class CircularBuffer
  class BufferEmptyException < StandardError; end
  class BufferFullException < StandardError; end

  def initialize size
    @max_size = size
    @buffer = []
  end

  def read
    raise BufferEmptyException if buffer.empty?

    v, *@buffer = buffer
    v
  end

  def write v
    return unless v
    raise BufferFullException if buffer.size == max_size

    buffer << v
  end

  def write! v
    write v
  rescue BufferFullException
    read
    write v
  end

  def clear; @buffer = []; end

  private

  attr_accessor :buffer, :max_size
end

# first implementation
# There is a quirk in this implementation:
#   Although `BufferFullException` is raised, `#write` will succeed writing.
#   buffer exeeds max size
class CircularBuffer1
  class BufferEmptyException < IndexError; end
  class BufferFullException < StandardError; end

  def initialize size
    @size = size
    @buffer = []
  end

  def read
    raise BufferEmptyException if buffer.empty?

    buffer.pop
  end

  def write v
    return unless v
    buffer.unshift v
    raise BufferFullException if over?

  end

  def write! v
    write v rescue BufferFullException

    buffer.pop if over?
  end

  def clear
    @buffer = []
  end

  private
  attr_accessor :buffer, :size

  def full?
    buffer.size == size
  end

  def over?
    buffer.size > size
  end
end

if __FILE__ == $0
  require 'benchmark'
  n = 500000
  Benchmark.bmbm do |x|
    x.report('destructuring') { n.times do
      buffer = CircularBuffer.new(5)
      ('1'..'3').each { |i| buffer.write i }
      buffer.read
      buffer.read
      buffer.write '4'
      buffer.read
      ('5'..'8').each { |i| buffer.write i }
        buffer.write! 'A'
        buffer.write! 'B'
      ('6'..'8').each do |i|
        buffer.read
      end

    end }

    x.report('popshift') { n.times do
      buffer = CircularBuffer1.new(5)
      ('1'..'3').each { |i| buffer.write i }
      buffer.read
      buffer.read
      buffer.write '4'
      buffer.read
      ('5'..'8').each { |i| buffer.write i }
        buffer.write! 'A'
        buffer.write! 'B'
      ('6'..'8').each do |i|
        buffer.read
      end

    end }
  end
end
