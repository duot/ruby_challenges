# frozen_string_literal: true

require 'pry'

# a**2 + b**2 = c**2
# c the greatest number
# a < b < c
#
class Triplet
  attr_reader :a, :b, :c
  def initialize(a, b, c)
    @a = a
    @b = b
    @c = c
  end

  def sum
    [a, b, c].sum
  end

  def product
    [a, b, c].reduce(&:*)
  end

  def pythagorean?
    a**2 + b**2 == c**2
  end

  # returns an array of Triplets
  def self.where(sum: nil, min_factor: 1, max_factor:)
    [*min_factor..max_factor].combination(3)
                             .each_with_object([]).each do |(a, b, c), result|
      triplet = new a, b, c
      next if sum && sum != triplet.sum

      result.push(triplet) if triplet.pythagorean?
    end
  end
end
