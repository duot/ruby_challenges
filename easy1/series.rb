
class Series
  def initialize str_numbers
    @numbers = str_numbers.chars.map(&:to_i)
  end

  def slices size
    raise ArgumentError, 'Size too big.' if size > @numbers.size
    @numbers.each_cons(size).to_a
  end
end
