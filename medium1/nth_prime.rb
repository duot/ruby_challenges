# frozen_string_literal: true

require 'pry'
# nth prime using Range.enumerator.lazy, and using brute force search
class Prime
  def self.nth(nth)
    raise ArgumentError if nth < 1

    prime_p = ->(n) { (2..Math.sqrt(n).to_i).none? { |d| (n % d).zero? } }
    (2..Float::INFINITY).lazy.select(&prime_p).each.with_index(1)
                        .find { |_prime, index| index == nth }
                        .first
  end
end

# naive nth prime
class Prime1
  def self.nth(nth)
    raise ArgumentError if nth < 1

    prime_enum.take(nth).last
  end

  def self.prime?(num)
    (2..Math.sqrt(num).to_i).none? { |divisor| (num % divisor).zero? }
  end

  def self.prime_enum
    Enumerator.new do |yielder|
      n = 2
      loop do
        yielder << n
        n += 1
        n += 1 until prime?(n)
      end
    end
  end
end
