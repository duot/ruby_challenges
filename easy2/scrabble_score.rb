class Scrabble# _table
  TABLE = {
    "A"=>1, "E"=>1, "I"=>1, "O"=>1, "U"=>1, "L"=>1, "N"=>1, "R"=>1, "S"=>1,
    "T"=>1, "D"=>2, "G"=>2, "B"=>3, "C"=>3, "M"=>3, "P"=>3, "F"=>4, "H"=>4,
    "V"=>4, "W"=>4, "Y"=>4, "K"=>5, "J"=>8, "X"=>8, "Q"=>10, "Z"=>10
  }

  def self.score word
    return 0 unless word.is_a? String
    return 0 unless word[0]
    return 0 if word[0] == ' '
    word.upcase.chars.map(&TABLE).sum
  end

  def initialize word
    @word = word
  end

  def score
    self.class.score @word
  end
end

class Scrabble_base
  A, E, I, O, U, L, N, R, S, T = 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
  D, G = 2, 2
  B, C, M, P = 3, 3, 3, 3
  F, H, V, W, Y = 4, 4, 4, 4, 4
  K = 5
  J, X = 8, 8
  Q, Z = 10, 10

  def self.score(word)
    return 0 unless word.is_a?(String)
    return 0 unless word[0]
    return 0 if word[0] == ' '
    return 0 if word[0] == ?\t
    return 0 if word[0] == ?\n
    # @word.upcase.chars.map(&method(:letter_score)).sum
    word = word.upcase
    (0...word.size)
      .map { |idx| const_get word[idx] }
      .sum
  end

  def initialize word
    @word = word
  end

  def score
    self.class.score @word
  end
end

class ScrabbleCase2
  def self.score word
    return 0 if word.nil?
    return 0 unless word[0]
    letters = word.upcase.chars

    score = proc do |letter|
      case letter
      when 'A', 'E', 'I', 'O', 'U', 'L', 'N', 'R', 'S', 'T' then  1
      when 'D', 'G'                         then  2
      when 'B', 'C', 'M', 'P'               then  3
      when 'F', 'H', 'V', 'W', 'Y'          then  4
      when 'K'                              then  5
      when 'J', 'X'                         then  8
      when 'Q', 'Z'                         then  10
      else 0
      end
    end
    letters.map(&score).sum
  end

  def initialize word
    @word = word
  end

  def score
    self.class.score @word
  end
end

class ScrabbleConstant2
  A, E, I, O, U, L, N, R, S, T = 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
  D, G = 2, 2
  B, C, M, P = 3, 3, 3, 3
  F, H, V, W, Y = 4, 4, 4, 4, 4
  K = 5
  J, X = 8, 8
  Q, Z = 10, 10

  def self.score(word)
    return 0 unless word.is_a?(String)
    return 0 unless word[0]
    return 0 if word[0] == ' '
    return 0 if word[0] == ?\t
    return 0 if word[0] == ?\n
    word = word.upcase
    # @word.upcase.chars.map(&method(:letter_score)).sum
    (0...word.size)
      .map { |idx| const_get word[idx] }
      .sum
  end

  def initialize word
    @word = word
  end

  def score
    self.class.score @word
  end
end

class ScrabbleConstant
  A, E, I, O, U, L, N, R, S, T = 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
  D, G = 2, 2
  B, C, M, P = 3, 3, 3, 3
  F, H, V, W, Y = 4, 4, 4, 4, 4
  K = 5
  J, X = 8, 8
  Q, Z = 10, 10

  def self.score(word)
    self.new(word).score
  end

  def initialize word
    #@letters = word.is_a?(String) ? word.upcase.chars : [' ']
    @word = word
  end

  def score
    return 0 unless @word.is_a?(String)
    @word.upcase.chars.map(&method(:letter_score)).sum
  end

  private

  def letter_score letter
    #case letter
    #when /\s/ then 0
    #else
    #  self.class.const_get letter
    #end
    return 0 if letter == ' '
    return 0 if letter == "\t"
    return 0 if letter == "\n"
    #val = self.class.const_get letter
    #val ? val : fail(letter)
    self.class.const_get letter
  end
end

#########
class ScrabbleCase
  def self.score word
    self.new(word).score
  end

  def initialize word
    @letters = word.is_a?(String) ? word.upcase.chars : [' ']
  end

  def letter_score letter
    case letter
    when 'A', 'E', 'I', 'O', 'U', 'L', 'N', 'R', 'S', 'T' then  1
    when 'D', 'G'                         then  2
    when 'B', 'C', 'M', 'P'               then  3
    when 'F', 'H', 'V', 'W', 'Y'          then  4
    when 'K'                              then  5
    when 'J', 'X'                         then  8
    when 'Q', 'Z'                         then  10
    else 0
    end
  end

  def score
    @letters.map(&method(:letter_score)).sum
  end
end

if __FILE__ == $0
  require 'benchmark'

  n = 50000
  # Benchmark.bmbm do |x|
  #   x.report('case') { n.times { ScrabbleCase.new('OXYPHENBUTAZONE').score} }
  #   x.report('case2') { n.times { ScrabbleCase2.new('OXYPHENBUTAZONE').score} }
  #   x.report('const') { n.times { ScrabbleConstant.new('OXYPHENBUTAZONE').score} }
  #   x.report('const2') { n.times { ScrabbleConstant2.new('OXYPHENBUTAZONE').score} }
  # end

  # Benchmark.bmbm do |x|
  #   x.report('case-class') { n.times { ScrabbleCase.score('OXYPHENBUTAZONE')} }
  #   x.report('const-class') { n.times { ScrabbleConstant.score('OXYPHENBUTAZONE')} }
  #   x.report('const2-class') { n.times { ScrabbleConstant2.score('OXYPHENBUTAZONE')} }
  #   x.report('case2-class') { n.times { ScrabbleCase2.score('OXYPHENBUTAZONE')} }
  # end

  Benchmark.bmbm do |x|
    x.report('case-new') { n.times { ScrabbleCase2.new('OXYPHENBUTAZONE').score} }
    x.report('case-class') { n.times { ScrabbleCase2.score('OXYPHENBUTAZONE')} }

    x.report('constant-new') { n.times { Scrabble_base.new('OXYPHENBUTAZONE').score} }
    x.report('constant-class') { n.times { Scrabble_base.score('OXYPHENBUTAZONE')} }

    x.report('table-new') { n.times { Scrabble_table.new('OXYPHENBUTAZONE').score} }
    x.report('table-class') { n.times { Scrabble_table.score('OXYPHENBUTAZONE')} }
  end
end
