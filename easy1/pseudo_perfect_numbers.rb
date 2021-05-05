require 'set'

# perfect has sum of factors(number) = number
# deficient  has sum less than number
# abundant has more
class PerfectNumber
  def self.classify n
    raise RuntimeError if n < 0
    solutions = %w[perfect abundant deficient]

    fac_sum = self.factors(n).sum
    solutions[fac_sum <=> n]
  end

  def self.factors(n) 
    facts = []
    (1...n).each do |m|
      facts << m if n % m == 0
    end

    facts
  end
end

if __FILE__ == $PROGRAM_NAME
  puts PerfectNumber.factors(48).to_a.sort.inspect
  puts PerfectNumber.factors(48).sum
  puts PerfectNumber.classify(6) # perfect
  puts PerfectNumber.classify(28) # perfect
  puts PerfectNumber.classify(7) # deficient
  puts PerfectNumber.classify(13) # deficient
end