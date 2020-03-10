require 'pry'

class Octal_
  def initialize octal
    cs = octal.chars
    @numerals = if valid? cs
      cs.map &:to_i
    else
      [0]
    end
  end

  def to_decimal
    powers = (0...numerals.size).to_a.reverse
    numerals
      .map
      .with_index { |n, i| n * 8 ** powers[i] }
      .sum
  end

  private

  attr_accessor :numerals

  def valid? oct
    oct.all? { |c| ('0'..'7').cover? c }
  end
end
# 4.507117   0.000497   4.507614 (  4.507798)

class Octal_
  def initialize octal
    @oct = octal.to_i.digits
  end

  def to_decimal
    @oct.map.with_index { |n, i| n * 8**i }.sum
  end
end
#1.899049   0.000000   1.899049 (  1.899174)

class Octal_
  def initialize octal
    @numerals = if valid? octal
      octal.to_i.digits
    else
      [0]
    end
  end

  def to_decimal
    @numerals.map
      .with_index { |n, i| n * 8 ** i }
      .sum
  end

  private

  attr_accessor :numerals

  def valid? oct
    oct.chars.all? { |c| ('0'..'7').cover? c }
  end
end
# 3.931056   0.000117   3.931173 (  3.931262)

class Octal
  def initialize(input)
    @input = input
  end

  def to_decimal
    return 0 if @input =~ /[^0-7]/
    @input.to_i.digits.map.with_index { |el, idx| el * 8**idx }.sum
  end
end
#0.928856   0.000026   0.928882 (  0.928901)

if __FILE__ == $0
  p Octal.new('1').to_decimal
  p Octal.new('1234acd').to_decimal

  require 'benchmark'

  puts Benchmark.measure {
    1_000_000.times do
      Octal.new('777_777').to_decimal
    end
  }
end
