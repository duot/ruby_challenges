require 'pry'

class Diamond
  def self.make_diamond(letter)
    new(letter).diamond
  end

  LETTERS = [*'A'..'Z']

  def initialize(letter)
    @given_letter = letter
  end

  def diamond
    return "A\n" if given_letter == 'A'
    top = [*'A'..given_letter]
    all = top + top.reverse.drop(1)
    all.map(&method(:line_builder)).join("\n") + "\n"
  end

  private

  attr_reader :letters, :given_letter

  def distance_from_a(letter = given_letter)
    LETTERS.index letter
  end

  def spaces_from_line_start(letter)
    range = [*-distance_from_a..distance_from_a]
    distances = range.map &:abs
    distances[distance_from_a(letter)]
  end

  def line_builder(letter)
    spaces = ' ' * spaces_from_line_start(letter)
    inner = letter + inner_spaces(letter) + letter
    inner = 'A' if letter == 'A'
    spaces + inner + spaces
  end

  def inner_spaces(letter)
    return '' if letter == 'A'
    filled = (spaces_from_line_start(letter) * 2) + 2
    width = [*'A'..given_letter].size * 2 - 1
    ' ' * (width - filled)
  end
end

# wall to char => 0 at the given_letter
# to_middle_size = ('A'..(given)).to_a.size
# height = (to_middle_size * 2) - 1

# range = -(to_mid_size)..to_mid
# [-2, -1, 0, 1, 2]
# a b c b a


# line builder
#  padding = ' ' * spaces_from_start 
#  padding + letter + inner_spaces + letter + padding
#
#
#  # inner_space
#  ' ' * distance_from_a + 1