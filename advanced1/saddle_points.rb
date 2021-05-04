class Matrix
  attr_reader :rows, :columns #, :memo_row, :memo_col

  def initialize(str)
    rows = str.split("\n")
    @grid = rows.map do |row_str|
      row_str.split(' ').map(&:to_i)
    end

    @rows = []

    @grid.each do |row|
      @rows.push(row)
    end

    @columns = []

    (0...@grid[0].length).map do |col_index|
      col = @grid.map { |row| row[col_index] }
      @columns.push(col)
    end

    @memo_row = []
    @memo_col = []
  end

  def saddle_points
    points = []

    (0...@grid.length).each do |i|
      (0...@grid[0].length).each do |j|
        points.push([i, j]) if sadde_point(i, j)
      end
    end

    points
  end

  def sadde_point(i, j)
    v = @grid[i][j]
    v == memo_row_max(i) && v == memo_col_min(j)
  end

  def memo_row_max(row_i)
    @memo_row[row_i] ||= rows[row_i].max
  end

  def memo_col_min(col_i) 
    @memo_col[col_i] ||= columns[col_i].min
  end
end


if __FILE__ == $PROGRAM_NAME
require "pry"
m = Matrix.new("1 2 3\n4 5 6\n7 8 9\n8 7 6")
debugger

1

end