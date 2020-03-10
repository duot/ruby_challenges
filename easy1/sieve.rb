class Sieve
  def initialize limit
    @limit = limit
  end

  def primes
    # data structure
      # init array with:
        # ar[index] -> index
    # ar[index] -> nil | index
    # ar[index] -> nil if composite
    # ar[index] -> index if prime
    # ar will be compacted

    ar = Array.new(limit) { |i| i }
    ar[0] = nil # implementation trade off
    ar[1] = nil # values not used

    (2..limit).each do |number|
      next unless ar[number] # skip until 'umarked' is found 
      sift! ar, number
    end
    
    ar.compact
  end

  private

  attr_reader :limit

  # iterates multiples of n, excluding n
  # ar[n] -> n
  # ar[n-multiple] -> nil
  def sift! ar, n
    multiples = Multiples.enum n, limit
    multiples.next
    loop do
      ar[multiples.next] = nil
    end
  end

  class Multiples
    def self.enum n, limit
      Enumerator.new do |yielder|
        acc = n
        loop do
          yielder << acc
          acc += n
          break if acc > limit
        end
      end 
    end
  end
end
#  2.457121   1.056061   3.513182 (  3.513239)

#class Sieve
#  attr_reader :range
#
#  def initialize(last_num)
#    @range = (2..last_num).to_a
#  end
#
#  def primes
#    range.each do |prime|
#      range.reject! { |num| (num != prime) && (num % prime == 0) }
#    end
#    range
#  end
#
#end
##  2.250020   0.003845   2.253865 (  2.254291) 
#
#class Sieve
#  attr_reader :numbers
#
#  def initialize(limit)
#    @numbers = [*(2..limit)]
#  end
#
#  def primes
#    primes = []
#
#    while (prime = numbers.delete_at(0))
#      primes << prime
#      numbers.delete_if { |number| number % prime == 0 }
#    end
#
#    primes
#  end
#end
##  1.018409   0.004016   1.022425 (  1.022455)
#
#class Sieve
#
#  FIRST_PRIME = 2
#
#  def initialize(limit)
#    @limit = limit
#  end
#
#  def primes
#    raise(ArgumentError) if @limit < FIRST_PRIME
#
#    range = (FIRST_PRIME..@limit)
#    primes = range.to_a
#
#    range.each do |t|
#      primes.reject! { |number| (number % t == 0) unless number == t }
#    end
#
#    primes
#  end
#end
## 11.622801   0.012250  11.635051 ( 11.635289)

if __FILE__ == $0
  p Sieve.new(10).primes
  p Sieve.new(1000).primes

  require 'benchmark'

  if ARGV.include? 'bench'
    puts Benchmark.measure {
      1000.times do
        Sieve.new(1000).primes
      end
    }
  end
end
