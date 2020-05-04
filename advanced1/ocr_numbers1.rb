require 'pry'

module GraphTable
  TABLE = {
    [
      ' ', ' ',
      ' ', ' ', '|',
      ' ', ' ', '|'
    ] => 1,
    [
      ' ', '_',
      ' ', '_', '|',
      '|', '_', ' '
    ] => 2,
[
      ' ', '_',
      ' ', '_', '|',
      '|', '_',
    ] => 2,
    [
      ' ', '_',
      ' ', '_', '|',
      ' ', '_', '|'
    ] => 3,
    [
      ' ', ' ',
      '|', '_', '|',
      ' ', ' ', '|'
    ] => 4,
    [
      ' ', '_',
      '|', '_', ' ',
      ' ', '_', '|'
    ] => 5, [
      ' ', '_',
      '|', '_',
      ' ', '_', '|'
    ] => 5, 
    [
      ' ', '_',
      '|', '_', ' ',
      '|', '_', '|'
    ] => 6,
[
      ' ', '_',
      '|', '_',
      '|', '_', '|'
    ] => 6,
    
    
    [
      ' ', '_',
      ' ', ' ', '|',
      ' ', ' ', '|'
    ] => 7,[
      ' ', '_',
      '|', '_', '|',
      '|', '_', '|'
    ] => 8,[
      ' ', '_',
      '|', '_', '|',
      ' ', '_', '|'
    ] => 9,[
      ' ', '_',
      '|', ' ', '|',
      '|', '_', '|'
    ] => 0
  }
end

module NumberLine 
  # divide by 4 String lines
  # drop the last
  def split_into_number_lines(text)
    number_lines = text.each_line.each_slice(4)
    drop_last(number_lines)
  end

  def drop_last(number_lines)
    number_lines.map { |nl| nl.take(3) }
  end
end

module Processor 
  include NumberLine

  private
  def split_into_patterns(text)
    number_lines = split_into_number_lines(text)
    number_lines.map do |nl|
      v_slices = vertical_sections(nl)
      h_slices = graph_sections(v_slices)
      graphs = transpose h_slices
    end
  end

  def transpose(graph_sections)
    size = graph_sections[0].size
    (0...size).map do |index|
      graph_sections.map { |v_slice| v_slice[index]}
    end
  end

  def vertical_sections(number_line)
    number_line.map &:chomp
  end

  def graph_sections(v_slices)
    v_slices.map { |line| slice_width3 line }
  end
  
  def slice_width3(horizontal)
    horizontal.chars.each_slice(3).to_a
  end
end

class OCR
  include Processor
  include GraphTable

  def initialize(text)
    @text = text
    @patterns = split_into_patterns(text)
  end

  def convert
    @patterns.map do |lines|
      lines.map { |graph|
        t = TABLE.fetch normalize(graph) do |x|
          binding.pry
           '?'
        end
      }.join
    end.join ','
  end

  private

  def normalize(graph)
    top, mid, bot = graph
    top = top.size < 3 ? top : top[0..1]

    [*top, *mid, *bot]
  end
end


if __FILE__ == $0
  require 'minitest/autorun'

  class NumberPatternTest < Minitest::Test
    def test_0
      text = <<-NUMBER.chomp
    _
  || |
  ||_|
  
      NUMBER
      text = <<-NUMBER.chomp
    _  _
  | _| _|
  ||_  _|

    _  _
|_||_ |_
  | _||_|

 _  _  _
  ||_||_|
  ||_| _|

      NUMBER
      assert_equal '123,456,789', OCR.new(text).convert
    end
  end
end

__END__

  

