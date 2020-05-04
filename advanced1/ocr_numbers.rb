require 'pry'

class OCR
  N = {
    " _ | | |_| " => "0",
    "   |   | " => "1",
    " _  _| |_ " => "2",
    " _  _|  _| " => "3",
" |_|   | " => "4",
    " _ |_  _| " => "5",
" _ |_ |_| " => "6",
" _   |   | " => "7",
" _ |_| |_| " => "8",
 " _ |_|  _| " => "9"
  }

  def initialize(text)
    @text = text
  end

  def convert
    number_line = @text.gsub("\n", ' ')
    same_length = @text.each_line.map { |line| handle_newline(line) }

    binding.pry
    partition_by3(number_line)
    N.fetch(key) do |x|
      binding.pry
      x
    end
  end

  private

  def handle_newline(line)
    if line.size % 3 == 0
      line.chomp
    else
      line.gsub "\n", ' '
    end
  end

  def partition_by3(number_line)
    size = cp.max_by(&:size).size


    (0...size).map do |index|
      v = cp.map { |line| line[index] }
      binding.pry
    end
  end
end
