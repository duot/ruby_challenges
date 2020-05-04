require 'pry'

module NeighborLocatable
  attr_reader :x, :y, :bound_x, :bound_y
  def top
    [x, y - 1]
  end

  def top_right
    [x + 1, y - 1]
  end

  def right
    [x + 1, y]
  end

  def bot_right
    [x + 1, y + 1]
  end

  def bot
    [x, y + 1]
  end

  def bot_left
    [x - 1, y + 1]
  end

  def left
    [x - 1, y]
  end

  def top_left
    [x - 1, y - 1]
  end

  def neighbors
    all_directions.filter { |(x, y)| inside_boundery x, y }
  end

  def inside_boundery(x, y)
    (0..bound_x).cover?(x) && (0..bound_y).cover?(y)
  end

  private

  def all_directions
    [top, top_right, right, bot_right, bot, bot_left, left, top_left]
  end
end

# A cell contains a cartesian coord and board size
# it responds to
# .mine?
# .adjacent_mines
# .add_adjacent
# .x
# .y
class Cell
  include NeighborLocatable

  attr_reader :adjacent_mine_count

  def initialize(x, y, bound_x, bound_y, init_char)
    @x = x
    @y = y
    @bound_x = bound_x
    @bound_y = bound_y
    @init_char = init_char
    @adjacent_mine_count = 0
  end

  def mine?
    @init_char == '*'
  end

  def add_adjacent_mine_count
    @adjacent_mine_count += 1
  end

  def to_s
    mine? ? @init_char : adjacent_mine_count.to_s
    if (mine?) then @init_char
    else
     adjacent_mine_count.zero? ? ' ' : adjacent_mine_count.to_s
    end
  end
end

class Board
  class ::ValueError < StandardError; end

  TOP_BORDER_LINE = /[\A\+\-{1,}\+\z]/
  WALL_MARKER = '|'

  def self.transform(inp)
    Board.new(inp).display_output_board
    false
  end

  attr_reader :input

  def initialize(input)
    raise ValueError unless valid?(input)

    bound_y = divided_char_grid(input).size
    bound_x = divided_char_grid(input)[0].size
    @cells_grid = chars_into_cells(input, bound_x, bound_y)
  end

  def display_output_board
    @binding.pry
    bump_count_of_adjacent_mines
  end

  private

  def bump_count_of_adjacent_mines
    cells_besides_mines.each do |x, y|
      cell = @cells_grid[x][y]
      #raise RuntimeError, "#{x}#{y}" unless cell
      next unless cell

      cell.add_adjacent_mine_count
    end
  end

  def mines
    @cells_grid.flatten.filter(&:mine?)
  end

  def cells_besides_mines
    mines.map(&:neighbors).flatten(1)
  end

  def divided_char_grid(input)
    @char_grid || @char_grid = content_lines(input).map(&:chars)
  end

  def chars_into_cells(input, bound_x, bound_y)
    divided_char_grid(input).map.with_index do |rows, y|
      rows.map.with_index do |char, x|
        Cell.new(x, y, bound_x, bound_y, char)
      end
    end
  end

  def valid?(input)
    all_same_length?(input) && borders_intact?(input) && valid_chars_used?(input)
  end

  def borders_intact?(input)
    top_and_bottom_borders_intact?(input) && side_walls_intact?(input)
  end

  def middle_lines(input)
    input[1...-1]
  end

  def side_walls_intact?(input)
    middle_lines(input).all? do |line|
      line[0] == WALL_MARKER && line[-1] == WALL_MARKER
    end
  end

  def top_and_bottom_borders_intact?(input)
    top = input.first
    bot = input.last
    [top, bot].all? { |line| line.match? TOP_BORDER_LINE}
  end

  def all_same_length?(input)
    input.map(&:size).uniq.size == 1
  end

  def valid_chars_used?(input)
    content_lines(input).none? { |line| line.match /[^\s*]/}
  end

  def content_lines(input)
    middle_lines(input).map{ |walled_line| walled_line[1...-1] }
  end
end

if __FILE__ == $PROGRAM_NAME
  c =  Cell.new(3,3,3,3,'*')
    binding.pry
  []
end
