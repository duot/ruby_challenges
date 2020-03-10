require 'pry'
require 'set'
class School
  def initialize
    @roster = Hash.new { |hash, grade| hash[grade] = [] }
  end

  def to_h
    roster.sort.to_h
  end

  def grade n
    roster[n].to_a
  end

  def add name, grade
    roster[grade] << name
    roster[grade].sort!
  end

  private

  attr_accessor :roster
end
