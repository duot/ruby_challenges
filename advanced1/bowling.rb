# frozen_string_literal: true

require 'pry'

# the game is 10 frames, 1..10
#   - thats 20 open frames
#   - or 10 strikes + n? fill

#   - or 10 spares + fill

# open
#   sum of 2 throws

# spare
#   sum of 2 throws = 10 + next throw

# strike
#   10 + throw 1 + throw 2

#   if throw 1 is strike

# fill ball
#     if 10th frame and
#     if spare or strike
#       if spare, 1 fill ball
#       if strike, 2 fill balls

# game ends
#   10th frame,
#     and either open,

#     or spare, strike and fill ball

# ----------
# what if
#   collect into array all throws
#     each throw, calculate frame
#         1 if strike
#           increment frame
#         2 if spare
#         2 if open

#   start with frame 0
#     increment each frame
#     error if rolls and frame is 10

#   allow score if frame is 10

# new_frame
#   frame++ if < 10
#   throw1 = nil
#   throw2 = nil

# roll(pins)
#   if 10 pins new_frame
#   else
#     if throw1
#       throw2 = pins
#       new_frame
#     else
#       throw1 = pins
# ---------------------------

# running total approach
#   spare and strike

# if strike
#   wait two rolls and sum the last 3 rolls

# if spare
#   wait 1 roll and sum the last 3 rolls

# roll(pins)
#   decrement wait
#     wait list . map decrement
#   compute running total if any in wait list is 0

#   rolls.push(pins)

#   compute frame

#   register wait
#     remove 0s

# compute_running_total
#   rolls take last 3 then sum
#   runing total += sum
# ____________________

# lessons learned:
#   in complicated rules:
#     walk through the procedure manually
class Game
  class FrameUnscorableError < StandardError; end

  # ignores unneeded throws, once the expected throws is met for scoring
  class Frame
    attr_reader :throw1, :throw2, :fill1, :fill2, :nth_frame

    def initialize(nth)
      @nth_frame = nth
    end

    def throw(pins)
      validate_no_extra_roll_on_10th
      validate_range(pins)

      if strike?
        if fill1
          @fill2 ||= pins

          validate_total_pin_count_on_lane
        else
          @fill1 = pins
        end
      elsif spare?
          @fill1 ||= pins
      else
        if throw1
          @throw2 ||= pins
          raise StandardError, 'Pin count exceeds pins on the lane' if throw1 + throw2 > 10
        else
          @throw1 = pins
        end
      end
    end

    def score
      if strike?
        10 + fill1 + fill2
      elsif spare?
        10 + fill1
      elsif open?
        both
      else
        raise FrameUnscorableError
      end
    end

    def frame?
      strike? || both
    end

    private

    def fill_balls_already_thrown?
      (strike? && fill1 && fill2) || (spare? && fill1)
    end

    def strike?
      throw1 == 10
    end

    def spare?
      both && both == 10
    end

    def open?
      both && both < 10
    end

    def both
      throw1 && throw2 && throw1 + throw2
    end

    def validate_total_pin_count_on_lane
      if fill1 < 10 && fill1 + fill2 > 10
        raise StandardError, 'Pin count exceeds pins on the lane'
      end
    end

    def validate_no_extra_roll_on_10th
      if nth_frame == 10 && (fill_balls_already_thrown? || open?)
        raise StandardError, 'Should not be able to roll after game is over'
      end
    end

    def validate_range(pins)
      raise StandardError, 'Pins must have a value from 0 to 10' unless (0..10).cover?(pins)
    end
  end

  def initialize
    @frames = [Frame.new(1)]
  end

  def roll(pins)
    last_frame = frames.last
    nth = frames.size
    @frames << Frame.new(nth + 1) if nth < 10 && last_frame.frame?

    frames.each { |frame| frame.throw(pins) }
  end

  def score
    frames.map(&:score).sum
  rescue FrameUnscorableError
    raise StandardError, 'Game is not over yet, cannot score!'
  end

  private

  attr_accessor :frames
end

if __FILE__ == $PROGRAM_NAME
  f = Game::Frame.new 10
  puts f

  g = Game.new
  g.score
end
