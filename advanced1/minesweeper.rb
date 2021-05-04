require 'pry'

class ValueError < StandardError; end

class Board
  def self.transform(input)
    fail ValueError, 'invalid input' unless valid?(input)

    output = Array.new(input.length) { Array.new(input[0].length) }
    
    input.each_with_index do |row, x|
      row.chars.each_with_index do |char, y|
        output[x][y] = transform_char(char, x, y, input)
      end
    end
    
    output.map(&:join)
  end

  def self.transform_char(char, x, y, input)
    return char unless char == ' '

    count = surrounding_mines(x, y, input)
    count == 0 ? ' ' : count.to_s
  end

  def self.surrounding_mines(x, y, input)
    [
      input[x][y+1], input[x+1][y+1], input[x+1][y], input[x+1][ y-1], input[x][ y-1], input[x-1][ y-1], input[x-1][ y], input[x-1][ y+1]
    ].count('*')
  end

  def self.valid?(input)
    rows_of_same_length(input) && valid_border_pattern(input) && valid_chars_used?(input)
  end

  def self.rows_of_same_length(input)
    input.all? { |row| row.length == input[0].length }
  end

  def self.valid_border_pattern(input)
    line = /^\+-*\+$/
    input[0].match(line) && input[-1].match(line)
  end

  def self.valid_chars_used?(input)
    input[1..-2].all? { |row| row.match(/^\|(\ |\*)*\|$/) }
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
