require 'pry'
class Luhn# _Reference
  def initialize(number)
    @digits = number.to_s.split('').map(&:to_i)
  end

  def number
    @digits.map(&:to_s).join.to_i
  end

  def addends
    @digits.reverse.each_with_index.map do |digit, index|
      if index.even?
        digit
      else
        digit * 2 > 9 ? digit * 2 - 9 : digit * 2
      end
    end.reverse
  end

  def checksum
    addends.reduce(&:+)
  end

  def valid?
    checksum % 10 == 0
  end

  def self.create(number)
    new_base_number = number * 10
    if new(new_base_number).valid?
      new_base_number
    else
      luhn_remainder = new(new_base_number).checksum % 10
      new_base_number + (10 - luhn_remainder)
    end
  end
end
__END__
class Luhn3
  class << self
    # increment the addends until valid
    def create n
      enum = (0..9001).lazy.map &:to_s
      digits_str = n.to_s
      new_dig = digits_str + enum.next
      sum = checksum (addends new_dig.to_i.digits)
      loop do
        break new_dig.to_i if valid? sum
        new_dig = digits_str + enum.next
        sum = checksum (addends new_dig.to_i.digits)
      end
    end

    # right to left, even indexed, doubled (subtract 9 if > 10)
    # in: Integer#digits (reversed)
    def addends(digits)
      doubled_ar = digits.each_with_index.map do |el, i|
        next el if i.even?
        doubled = el * 2
        doubled -= 9 if doubled > 9
        doubled
      end

      doubled_ar.reverse
    end

    def checksum(addends)
      addends.sum
    end
    # checksum ends with 0
    def valid?(checksum)
      0 == checksum % 10
    end
  end

  def sefl.create n
    if new(n).valid?
  end

  def initialize n
    @digits_in = n.digits
  end
  def valid?
    self.class.valid? checksum
  end

  def addends
    self.class.addends @digits_in
  end

  def checksum
    self.class.checksum addends
  end
end

class Luhn2
  class << self
    # increment the addends until valid
    def create n
      enum = (0..9001).lazy.map &:to_s
      digits_str = n.to_s
      new_dig = digits_str + enum.next
      sum = checksum (addends new_dig.to_i.digits)
      loop do
        break new_dig.to_i if valid? sum
        new_dig = digits_str + enum.next
        sum = checksum (addends new_dig.to_i.digits)
      end
    end

    # right to left, even indexed, doubled (subtract 9 if > 10)
    # in: Integer#digits (reversed)
    def addends(digits)
      doubled_ar = digits.each_with_index.map do |el, i|
        next el if i.even?
        doubled = el * 2
        doubled -= 9 if doubled > 9
        doubled
      end

      doubled_ar.reverse
    end

    def checksum(addends)
      addends.sum
    end
    # checksum ends with 0
    def valid?(checksum)
      0 == checksum % 10
    end
  end

  def initialize n
    @digits_in = n.digits
  end
  def valid?
    self.class.valid? checksum
  end

  def addends
    self.class.addends @digits_in
  end

  def checksum
    self.class.checksum addends
  end
end

<<L

L
class Luhn1
  class << self
    # increment the addends until valid
    def create n
      enum = (0..9001).lazy.map &:to_s
      digits_str = n.to_s
      new_dig = digits_str + enum.next
      sum = checksum (addends new_dig.to_i.digits)
      loop do
        break new_dig.to_i if valid? sum
        new_dig = digits_str + enum.next
        sum = checksum (addends new_dig.to_i.digits)
      end
    end

    # right to left, even indexed, doubled (subtract 9 if > 10)
    def addends(digits)
      doubled_ar = digits.each_with_index.map do |el, i|
        next el if i.even?
        doubled = el * 2
        doubled > 9 ? (doubled - 9) : doubled
      end

      doubled_ar.reverse
    end

    def checksum(addends)
      addends.sum
    end
    # checksum ends with 0
    def valid?(checksum)
      0 == checksum % 10
    end
  end

  def initialize n
    @digits_in = n.digits
  end
  def valid?
    self.class.valid? checksum
  end

  def addends
    self.class.addends @digits_in
  end

  def checksum
    self.class.checksum addends
  end
end
