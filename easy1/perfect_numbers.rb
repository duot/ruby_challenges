class PerfectNumber
  def self.classify n
    raise RuntimeError if n < 0

    factors = (1...n).select { |m| n % m == 0}
    %w[perfect abundant deficient][factors.sum <=> n]
  end
end

class PerfectNumber_3
  def self.classify n
    raise RuntimeError if n < 0

    factors = (1...n).select { |m| n % m == 0}
    case factors.sum <=> n
    when 0 then 'perfect'
    when -1 then 'deficient'
    when 1 then 'abundant'
    end
  end
end

class PerfectNumber_class
  def self.classify n
    raise RuntimeError if n < 0

    case factors(n).sum <=> n
    when 0 then 'perfect'
    when -1 then 'deficient'
    when 1 then 'abundant'
    end
  end

  def self.factors n
    (1...n).select { |m| n % m == 0 }
  end
end

class PerfectNumber_new
  def self.classify n
    raise RuntimeError if n < 0

    case PerfectNumber_new.new.factors(n).sum <=> n
    when 0 then 'perfect'
    when -1 then 'deficient'
    when 1 then 'abundant'
    end
  end

  def initialize
  end

  def factors n
    (1...n).select { |m| n % m == 0 }
  end
end

if __FILE__ == $0
  p PerfectNumber_class.factors(99)


  require 'benchmark'
  n = 50000
  Benchmark.bmbm do |x|
    x.report('new') { n.times { PerfectNumber_new.classify 1000 }}
    x.report('class') { n.times { PerfectNumber_class.classify 1000 }}
    x.report('class3') { n.times { PerfectNumber_3.classify 1000 }}
    x.report('final') { n.times { PerfectNumber.classify 1000 }}
  end
end

__END__
             user     system      total        real
new      4.211804   0.000000   4.211804 (  4.211910)
class    4.145024   0.000000   4.145024 (  4.145121)
class3   3.984930   0.000000   3.984930 (  3.985006)
final    4.097460   0.000000   4.097460 (  4.097546)

