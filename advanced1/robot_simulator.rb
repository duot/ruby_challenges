# frozen_string_literal: true

# To shift location, simply call the cardinal direction
# E.g:
#    `location_instance.method(bearing).call`
#    `location_instance.north`
class Location
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def north
    @y = y + 1
  end

  def east
    @x = x + 1
  end

  def south
    @y = y - 1
  end

  def west
    @x = x - 1
  end
end

### A robot faces 1 of 4 directions. Each direction is represented internally as
# an integer. A turn is simply a direction code increment/decrement.
class Robot
  DIRECTION = %i[north east south west].freeze
  LEFT = :pred
  RIGHT = :next

  attr_reader :bearing

  def orient(direction)
    err = "Unknown direction: #{direction}."
    raise ArgumentError, err unless DIRECTION.any? direction

    @bearing = direction
  end

  def at(x__, y__)
    @location = Location.new(x__, y__)
  end

  def coordinates
    [location.x, location.y]
  end

  def advance
    raise 'Location not set.' if location.nil?

    location.method(bearing).call
  end

  def turn_left
    turn LEFT
  end

  def turn_right
    turn RIGHT
  end

  private

  attr_accessor :location

  def turn(which_way)
    new_direction_index = DIRECTION.index(bearing).method(which_way).call
    @bearing = DIRECTION[new_direction_index % 4]
  end
end

# Each instruction corresponds to Robot methods.
class Simulator
  INSTRUCTIONS = {
    'A' => :advance, 'L' => :turn_left, 'R' => :turn_right
  }.freeze

  def instructions(codes)
    codes.chars.map { |code| INSTRUCTIONS[code] }
  end

  def place(robot, **options)
    robot.at(options[:x], options[:y])
    robot.orient(options[:direction])
  end

  def evaluate(robot, string_codes)
    instructions(string_codes).each { |step| robot.method(step).call }
  end
end
