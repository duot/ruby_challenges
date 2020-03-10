class DNA
  attr_reader :strand
  def initialize strand
    @strand = strand
  end

  def hamming_distance dist
    idx = 0
    points = 0
    loop do
      return points unless strand[idx] && dist[idx]
      points += 1 if strand[idx] != dist[idx]
      idx += 1
    end
  end
end

class DNA_bob_rodes_soln
  def initialize(strand)
    @strand = strand
  end

  def hamming_distance(strand_2)
    hd = 0
    s1, s2 = @strand.each_char, strand_2.each_char
    loop do
      hd += 1 unless s1.next == s2.next
    end
    hd
  end
end

if __FILE__ == $0
  require 'benchmark'

  strand = 'GGACGGATTCTGACCTGGACTAATTTTGGGG'
  distance = 'AGGACGGATTCTGACCTGGACTAATTTTGGGG'

  n = 50000
  Benchmark.bmbm do |x|
    x.report('String#[]') { n.times { DNA.new(strand).hamming_distance(distance)}}
    x.report('external_iterators') { n.times { DNA_bob_rodes_soln.new(strand).hamming_distance(distance)}}
  end
end
