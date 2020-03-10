# frozen_string_literal: true

require 'pry'
require 'date'

class MeetupReferenceSolution
  def initialize(month, year)
    @month = month
    @year = year
    @schedule_start_day = {
      first: 1,
      second: 8,
      third: 15,
      fourth: 22,
      last: -7,
      teenth: 13
    }
  end

  def day(weekday, schedule)
    first_day = Date.new(@year, @month, @schedule_start_day[schedule])
    (first_day..(first_day + 6)).detect {|day| day.public_send(weekday.to_s + '?')}
  end
end

# Define a class Meetup with a constructor taking a month and a year
# and a method day(weekday, schedule)
# where weekday is one of :monday, :tuesday, etc
# and schedule is :first, :second, :third, :fourth, :last or :teenth.
class Meetup
  ORDINALS = %i[first second third fourth].zip(0...4).to_h

  def initialize(month, year)
    @date = Date.new(year, month)
    @date_enum = date_enum_new year, month
  end

  def day(day, ordinal)
    day_sym = day_to_predicate(day)
    days = date_enum.select(&day_sym)
    return days[ORDINALS.fetch(ordinal)]
  rescue KeyError
    if ordinal == :last
      days.last
    else
      days.find { |d| teenth? d.day }
    end
  end

  private

  attr_accessor :date_enum

  def ordinal_key(ord)
    ords = :first, :second, :third, :fourth, :last, :teenth
    ords.index ord
  end

  def day_to_predicate(day_symbol)
    :"#{day_symbol}?"
  end

  def teenth?(day_n)
    (13..19).cover? day_n
  end

  def date_enum_new(year, month)
    d = Date.new year, month
    d.upto(d.next_month - 1)
  end
end
