A key distinction of the [genuine](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes#cite_note-ONeill-2) Sieve of Eratosthenes is *how* the multiples of a number is generated. They are generated iteratively, using [constant difference](https://en.wikipedia.org/wiki/Arithmetic_progression). The problem description above itself says it so.

This is opposed to testing with [trial division](https://en.wikipedia.org/wiki/Trial_division). Using `number % prime == 0` isn't really sieving.

```ruby
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
```
