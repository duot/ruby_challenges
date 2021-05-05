require 'minitest/autorun'
require 'pry'

require_relative 'rail_fence_cipher'

class Line < Minitest::Test
  def test_line_fill_only_content_length_chars
    chars = "abcde".chars
    line = Line.new(false, 3, 2)
    line.fill! chars
    binding.pry
    assert_equal chars, ['d', 'e']
  end

  def test_line_fill_downwards_only_takes_content_lenght_chars
  end
end