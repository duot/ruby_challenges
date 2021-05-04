require 'pry'

module NeighborLocatable
  attr_reader :x, :y, :width, :height
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
    (0...width).cover?(x) && (0...height).cover?(y)
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

  def initialize(x, y, width, height, init_char)
    @x = x
    @y = y
    @width = width
    @height = height
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
  end

  attr_reader :input
  
  
  # TODO remove
  attr_reader :cell_grid, :width, :height, :char_grid

  def initialize(input)
    raise ValueError unless valid?(input)

    @char_grid = divided_char_grid(input)
    @height = @char_grid.size
    @width = @char_grid[0].size
    @cell_grid = char_grid_to_cell_grid(char_grid, width, height)
  end

  def display_output_board
    bump_count_of_adjacent_mines
    inner_board_output
    border_wrap(chars_of_cell_grid, width)
  end

  #private

  def border_wrap(chars_grid, width)
    result = []
    line = "+#{'-' * width}+"

    inner = chars_grid.flat_map(&:join).map { |row| "|#{row}|" }

    inner.unshift(line).push(line)
  end

  def inner_board_output
    chars_of_cell_grid.flat_map(&:join).join "\n"
  end


  def chars_of_cell_grid
    @cell_grid.map { |row| row.flat_map(&:to_s) }
  end

  def bump_count_of_adjacent_mines
    xy_of_cells_besides_mines.each do |(x, y)|
      raise RuntimeError, "#{x} is nil" unless x
      raise RuntimeError, "#{y} is nil" unless y

      cell = @cell_grid.dig y, x
      raise RuntimeError, "There's no cell at #{x} #{y}" unless cell

      cell.add_adjacent_mine_count
    end
  end

  def mines
    @cell_grid.flat_map { |row| row.filter(&:mine?) }
  end

  def xy_of_cells_besides_mines
    # mines.map(&:neighbors).flatten(1)
    mines.flat_map(&:neighbors)
  end

  def divided_char_grid(input)
    @char_grid || @char_grid = content_lines(input).map(&:chars)
  end

#  def chars_into_cells(input, width, height)
#    divided_char_grid(input).map.with_index do |rows, y|
#      rows.map.with_index do |char, x|
#        Cell.new(x, y, width, height, char)
#      end
#    end
#  end

  def char_grid_to_cell_grid(char_grid, width, height)
    char_grid.map.with_index do |rows, y|
      rows.map.with_index do |char, x|
        Cell.new(x, y, width, height, char)
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
  inp = ['+------+', '| *  * |', '|  *   |', '|    * |', '|   * *|',
         '| *  * |', '|      |', '+------+']
      
  b = Board.new(inp)
  b02 = b.cell_grid.dig 0, 2
  bn = b02.neighbors
  binding.pry
  puts "end"
end
