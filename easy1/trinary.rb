class Trinary
  def initialize input
    @input = input
  end

  def to_decimal
    return 0 if @input =~ /[^0-2]/
    @input.to_i.digits.map.with_index { |el, idx| el * 3 ** idx }.sum
  end
end
