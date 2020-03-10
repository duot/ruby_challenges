# frozen_string_literal:true

# Clock independent of date
class Clock
  def self.at(hour, min = 0)
    new hour, min
  end

  def initialize(hour, min)
    @hour = hour
    @min = min
  end

  def to_s
    "#{pad @hour}:#{pad @min}"
  end

  def +(minutes)
    adjust_with minutes, &:+
  end

  def -(minutes)
    adjust_with minutes, &:-
  end

  def ==(other)
    hour == other.hour && min == other.min
  end

  protected

  attr_reader :hour, :min

  private

  def adjust_with(minutes, &block)
    additional_hour, new_min = [@min, minutes].reduce(&block).divmod 60
    new_hour = @hour + additional_hour
    new_hour %= 24
    self.class.new new_hour, new_min
  end

  def pad(number)
    padded = '0' * 2 + number.to_s
    padded[-2..-1]
  end
end
