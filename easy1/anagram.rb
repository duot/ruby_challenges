class Anagram
  def initialize word
    @word = word.downcase
    @hash = {}
    word.downcase.chars.each { |letter| @hash[letter] = true }

    @letters = @word.chars.sort
    # @anagram_signature = word.downcase.chars.group_by &:ord
  end

  def _match words
    words.select do |listed_word|
      lc = listed_word.downcase
      next if word == lc
      anagram_signature == lc.chars.group_by(&:ord)
    end
  end

  def match words
    words.select do |w|
      w = w.downcase
      next if word == w
      letters == w.chars.sort
    end
  end

  def _match words
    words.select do |w|
      w = w.downcase
      next if word == w
      w.chars.all? { |c| hash[c] }
    end
  end

  private

  attr_reader :letters, :word, :hash # :anagram_signature
end

class Soln1
  def initialize word
    @original_word = word
    @letters = letters @original_word
  end

  def match possibilities
    possibilities.sort.select { |word| anagram? word }
  end

  private

  def anagram? word
    @letters == letters(word) && @original_word != word.downcase
  end

  def letters word
    word.downcase.chars.sort
  end
end

class Soln2
  attr_reader :word, :letters

  def initialize(word)
    @word = word.downcase
    @letters = @word.chars.sort
  end

  def sorted_letters(str)
    str.downcase.chars.sort
    #yeah I could have just put this in my select block, but this looks nicer
  end

  def match(word_array)
    word_array.select { |ana| sorted_letters(ana) == letters && ana.downcase != word }
  end
end

class Soln3
  def initialize(word)
    @word = word.downcase
  end

  def match(words)
    words.select { |word| anagrams?(word) }
  end

  def anagrams?(word)
    word.downcase != @word &&
    word.downcase.chars.sort == @word.chars.sort
  end
end

if __FILE__ == $0
  require 'benchmark'
  word = 'allergy'
  list = %w( gallery ballerina regally clergy largely leading)

  n = 50000
  Benchmark.bmbm do |x|
    x.report('anagram') { n.times { Anagram.new(word).match list } }
    x.report('soln1') { n.times { Soln1.new(word).match list } }
    x.report('soln2') { n.times { Soln2.new(word).match list } }
    x.report('soln3') { n.times { Soln3.new(word).match list } }
  end
end
