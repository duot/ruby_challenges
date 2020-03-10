require 'pry'

class SumOfMultiples
  DEFAULT_MULTIPLES = [3, 5]

  def self.to limit
    SumOfMultiples.new(*DEFAULT_MULTIPLES).to limit
  end

  def initialize *multiples
    @multiples = multiples
  end

  def to limit
    to_generic @multiples, limit
  end

  private

  def to_generic multiples, limit
    multiples
      .flat_map { |m| all_multiples_array m, limit }
      .uniq
      .sum
  end

  def all_multiples_array n, limit
    result = []
    acc = n < limit ? n : 0
    loop do
      result << acc
      acc += n
      break result unless acc < limit
    end
  end
end

class SumOfMultiples_class_based
  DEFAULT_MULTIPLES = [3, 5]

  def self.to limit
    to_generic DEFAULT_MULTIPLES, limit
  end

  def self.to_generic multiples, limit
    multiples
      .flat_map { |m| all_multiples_array m, limit }
      .uniq
      .sum
  end

  def self.all_multiples_array n, limit
    result = []
    acc = n < limit ? n : 0
    loop do
      result << acc
      acc += n
      break result unless acc < limit
    end
  end

  def initialize *multiples
    @multiples = multiples
  end

  def to limit
    self.class.to_generic @multiples, limit
  end
end

if __FILE__ == $0
  require 'benchmark'

class SumOfMultiples_soln1
  def self.to(limit, multiples = [3, 5])
    (0...limit).select do |number|
      multiples.any? { |multiple| number % multiple == 0 }
    end.reduce(:+)
  end

  def initialize(*multiples)
    @multiples = multiples
  end

  def to(limit)
    self.class.to(limit, @multiples)
  end
end

#!/usr/bin/env ruby
# Copyright (c) 2016 Pete Hanson
# frozen_string_literal: true

class SumOfMultiples_soln2
  def initialize *multiples
    @multiples = multiples.empty? ? [3, 5] : multiples
  end

  def self.to up_to
    SumOfMultiples.new.to up_to
  end

  def to up_to
    (1...up_to).select { |number| multiple? number }
               .inject(0) { |sum, number| sum + number }
  end

  private

  def multiple? number
    @multiples.any? { |multiple| number % multiple == 0 }
  end
end

class SumOfMultiples_soln3
  attr_reader :multiples_of

  def self.to(max)
    SumOfMultiples.new(3, 5).to(max)
  end

  def initialize(*multiples_of)
    @multiples_of = multiples_of
  end

  def to(max)
    multiples_sum = 0
    (1...max).each { |num| multiples_sum += num if multiple?(num, multiples_of) }
    multiples_sum
  end

  private

  def multiple?(num, multiples_of)
    multiples_of.any? { |multiple| num % multiple == 0 }
  end
end

  n = 50000
  Benchmark.bmbm do |x|
    # x.report('soln1') { n.times { SumOfMultiples_soln1.new(43,47).to 10_000 }}
    # x.report('soln2') { n.times { SumOfMultiples_soln2.new(43,47).to 10_000 }}
    # x.report('soln3') { n.times { SumOfMultiples_soln3.new(43,47).to 10_000 }}
    x.report('class_method_exposed') { n.times { SumOfMultiples_class_based.new(43,47).to 10_000 }}
    x.report('iterative') { n.times { SumOfMultiples.new(43,47).to 10_000 }}
  end
end
