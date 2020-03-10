require 'pry'

  # String and Integer both respond to #to_i
  # Integer has a #[] method, returning the nth bit
  #   eg      3[1] -> 1
  #   3.to_s(2)[1] -> '1'

# keys are `keys` to the constant EVENT
# value of 1 selects the element
class SecretHandshake
  EVENTS = ['wink', 'double blink', 'close your eyes', 'jump'].freeze

  def initialize input # string || int
    *bits, @reverse_flag = (0..4).map &input.to_i.method(:[])

    @keys = bits
  end

  def commands
    result = @keys.zip(EVENTS).select { |k, _| k == 1}.map(&:last)
    @reverse_flag.zero? ? result : result.reverse
  end
end

class SecretHandshake2
  T = ['wink', 'double blink', 'close your eyes', 'jump'].freeze
  #T= ['jump', 'close your eyes', 'double blink', 'wink']


  def initialize n
    binary = lpad(n.to_i.to_s 2)
    flag, *bits = binary.chars
    @reverse_flag = flag == '1'

    # keys are `keys` to the constant `T`
    @keys = bits.reverse
  end

  def commands
    result = @keys.zip(T).select { |k, _| k == '1'}.map(&:last)
    @reverse_flag ? result.reverse : result
  end

  # pad zeros on the left
  def lpad n, size = 5
    s = "0" * 5 + n
    s[-5..-1]
  end
end

<<IO
    1 = wink
   10 = double blink
  100 = close your eyes
 1000 = jump
10000 = reverse the order

11001 = [ 'jump' 'wink ]
 .  .


1 > 0 0001 > wink . . .
2 > 0 0010 > . double . .
3 > 0 0011 > wink double . .
4 > 0 0100 > . . close .
.
.
.
8 > 0 1000 > . . . jump
IO

class SecretHandshake1
  T = 'wink', 'double blink', 'close your eyes', 'jump'
  # T = :reverse, 'jump', 'close your eyes', 'double blink', 'wink'

  attr_reader :keys, :n

  def initialize n
    @n = n.to_i
    @reverse_flag, *bits = lpad(bin @n).chars

    # keys are `keys` to the constant `T`
    @keys = bits.reverse
  end

  def commands
    result = @keys.zip(T).select { |k, _| k == '1'}.map(&:last)
    @reverse_flag == '1' ? result.reverse : result
  end

  def bin n
    n.to_s 2
  end

  def dec s
    s.to_i 2
  end

  # pad zeros on the left
  def lpad n, size = 5
    s = '0' * size + n
    s[-5..-1]
  end
end
