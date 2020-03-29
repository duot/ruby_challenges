# frozen_string_literal: true

require 'pry'

# Palindromes, iteration 3
# palindromes in the middle (of min, and max)
# are still not used
class Palindromes
  # Container for one palindrome
  class Palindrome
    %i|factors value|.map(&method(:attr_reader))

    def initialize(value, factors)
      @value = value
      @factors = factors
    end
  end
  
  def initialize(max_factor:, min_factor: 1)
    @max_factor = max_factor
    @min_factor = min_factor
    @palindromes = Hash.new { |hash, elm| hash[elm] = [] }
  end

  # generate all the palindromes
  # store it in hash where:
  # palindrome => [factors]
  def generate
    factors(@min_factor, @max_factor).each do |a, b|
      product = a * b
      @palindromes[product] << [a, b] if palindrome? product.to_s
    end
  end

  def smallest
    pal, factors = @palindromes.min
    Palindrome.new pal, factors
  end

  # returns the largest palindromic number
  # from the generated list
  def largest
    pal, factors = @palindromes.max
    Palindrome.new pal, factors
  end

  private

  def factors(from, to)
    [*from..to].repeated_combination(2).to_a
  end

  def palindrome?(digits)
    digits.reverse == digits
  end
end

__END__
class Palindromes2
  class Palindrome
    %i|factors value|.map &method(:attr_reader)

    def initialize(value, factors)
      @factors, @value = factors, value
    end
  end

  def initialize(max_factor:, min_factor: 1)
    @max_factor, @min_factor = max_factor, min_factor
    @max_palindrome, @min_palindrome = nil, nil
  end

  # generate all the palindromes
  # store it in hash where:
  # palindrome => [factors]
  def generate
    @factors = Hash.new { |hash, elm| hash[elm] = [] }

    products(@min_factor, @max_factor).each do |a, b|
      product = a * b
      if palindrome? product.to_s
        @factors[product] << [a, b]
      end
    end
  end

  def smallest
    product, factors = @factors.min
    Palindrome.new product, factors.to_a
  end

  # returns the largest palindromic number
  # from the generated list
  def largest
    product, factors = @factors.max
    Palindrome.new product, factors.to_a
  end

  private

  def products(from, to)
    [*from..to].repeated_combination(2).to_a
  end

  def palindrome?(digits)
     digits.reverse == digits
  end
end

# naive implementation
class Palindromes1
  class Palindrome
    %i|factors value|.map &method(:attr_reader)

    def initialize(factors, value)
      @factors, @value = factors, value
    end
  end

  def initialize(max_factor:, min_factor: 1)
    @max_factor, @min_factor = max_factor, min_factor
  end

  # generate all the palindromes
  def generate
     @factors = products(@min_factor, @max_factor).select do |(a, b)|
       palindrome? (a * b).to_s
     end
  end

  def smallest
    multiply = ->factors_ar { factors_ar.reduce &:* }
    smallest_product = @factors.map(&multiply).min
    smallest_factors = @factors.select {|a, b| a * b == smallest_product}
                              .map(&:sort).uniq
    Palindrome.new smallest_factors, smallest_product
  end

  # returns the largest palindromic number
  # from the generated list
  def largest
    multiply = ->factors_ar { factors_ar.reduce &:* }
    largest_product = @factors.map(&multiply).max
    largest_factors = @factors.select {|a, b| a * b == largest_product}
                              .map(&:sort).uniq
    Palindrome.new largest_factors, largest_product
  end

  private

  def products(from, to)
    (from..to).to_a.product (from..to).to_a
  end

  def palindrome?(digits)
     digits.reverse == digits
  end
end

if __FILE__ == $0
  require 'benchmark'
  n = 5
  Benchmark.bmbm do |x|
    x.report('pal2') { n.times do
      palindromes = Palindromes.new(max_factor: 999, min_factor: 100)
      palindromes.generate
      largest = palindromes.largest
      largest.value
      largest.factors
    end
    }
    
    x.report('naive') { n.times do
      palindromes = Palindromes1.new(max_factor: 999, min_factor: 100)
      palindromes.generate
      largest = palindromes.largest
      largest.value
      largest.factors
    end
    }
  end
end
