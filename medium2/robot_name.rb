require 'set'
class Robot
  @@names = Set.new
  attr_reader :name
  def initialize
    @name = nil
    reset
  end

  def reset
    @@names.delete @name
    name = uniq_random_name
    @@names << name
    @name = name
  end

  private

  def uniq_random_name
    name = generate 
    name = generate while @@names.include? name
    name
  end

  def generate
    letters = [*'A'..'Z']
    l = -> { letters.sample }
    n = -> { rand 9 }

    [l, l, n, n, n].map(&:call).join
  end
end
