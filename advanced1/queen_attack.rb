require 'pry'

class Queens
  attr_reader :white, :black 

  def initialize(white: [0, 3], black: [7, 3])
    raise ArgumentError if white == black
    @board = (0...8).map do |x|
      (0...8).map { |y| '_'}
    end

    @white = white
    @black = black

    y, x = white
    @board[y][x] = 'W'
    y, x = black
    @board[y][x] = 'B'
  end

  def to_s
    @board.map {|row| row.join(' ') }.join("\n")
  end

  def attack?
    samex? || samey? || samediag?
  end

  private

  def samex?
    @white[1] == @black[1]
  end

  def samey?
    @white[0] == @black[0]
  end

  def samediag?
    lowy, highy = [@white, @black].sort { |a, b| a[0] <=> b[0] }
    sameforwardslope(lowy) || samebackwardslope(lowy)
  end

  def sameforwardslope(lowy)
    ay, ax = lowy
    loop do 
      ay += 1
      ax += 1
      break false if ay > 7 || ax > 7
      break true if @board[ay][ax] != '_'
    end
  end
  
  def samebackwardslope(lowy)
    ay, ax = lowy
    loop do
      ay += 1
      ax -= 1
      break false if ay > 7 || ax < 0
      break true if @board[ay][ax] != '_'
    end
  end
end