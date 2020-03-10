# require 'strscan'

class Phrase
  def initialize phrase
    @words = phrase
      .downcase
      .scan(/\d+|[a-z']+/)
      .map! { |word|
        word[0] == "'" ? word[1..-2] : word
      }
  end

  def word_count
    # ruby 2.7
    @words.tally
    # @words.group_by(&:itself).transform_values(&:count)
  end
end

class Phrase_1
  WORD_PATTERN = /[[:alnum:]]+(\'\w)?/
  WORD_PATTERN2 = /([\w\d]+)(\'\w)?/
  WORD_PATTERN3 = /\'([\w']+)\'|\b[\w]+\'/
    #word
      /\b\w+\b/
    #quoted word
    #word apostrophe
      /\b\w+\'/


  def initialize phrase
    @phrase = phrase
  end

  private
  attr_reader :phrase

  def word_count_scan
    @phrase
      .scan(WORD_PATTERN2)
      .map(&:join)
      .each
      .with_object(Hash.new(0)) { |word, hash|
        hash[word.downcase] += 1
      }
  end

  def word_enum phrase
    Enumerator.new { |yielder|
      loop do
        _, match, rest = phrase.partition WORD_PATTERN
        break if match == ''
        yielder << match.downcase
        phrase = rest
      end
    }
  end

  def word_count_enum_partition
    en = word_enum @phrase
    hash = Hash.new 0
    loop do
      hash[en.next] += 1
    end
    hash
  end

  def word_count_partition
    phrase = @phrase
    hash = Hash.new 0
    loop do
      _, match, rest = phrase.partition WORD_PATTERN3
      break hash if match == ''
      hash[match.downcase] += 1
      phrase = rest
    end
  end

  alias word_count word_count_partition

  public :word_count
end


class Phrase_2
  def initialize phrase
    @words = partition(phrase.downcase)
      .map { |word| # splice quotes, leave apostrophe
        word[0] == "'" ? word[1..-2] : word
      }
  end

  def word_count
    @words.group_by(&:itself).transform_values(&:count)
  end

  # expects downcased
  def partition phrase
    words = []
    loop do
      _, match, rest = phrase.partition /\d+|[a-z']+/
      break words if match == ''
      words << match
      phrase = rest
    end
  end
end

if __FILE__ == $0
  require 'benchmark'
  n = 500000
  Benchmark.bmbm do |x|
    x.report('scan') { n.times {
      Phrase.new("Joe can't tell between 'large' and large.").word_count#_scan
    }}
  #  x.report('enum-partition') { n.times {
  #    Phrase.new("Joe can't tell between 'large' and large.").word_count_enum_partition
  #  }}
  #  x.report('partition') { n.times {
  #    Phrase.new("Joe can't tell between 'large' and large.").word_count_partition
  #  }}
  end
end

__END__
                     user     system      total        real
scan             7.265323   0.000000   7.265323 (  7.265499)
scan-gsub        5.616962   0.000000   5.616962 (  5.617045)
scan-delete      5.043552   0.000000   5.043552 (  5.044014)
scan-splices     4.897124   0.000000   4.897124 (  4.897226)
scan-splice-map! 4.880718   0.000000   4.880718 (  4.880755)
enum-partition  16.619201   4.503036  21.122237 ( 21.125597)
partition        6.689595   0.000266   6.689861 (  6.690042)
partition-splice 7.749753   0.000000   7.749753 (  7.749867)
scan-tally       4.298023   0.000000   4.298023 (  4.298086)
