# frozen_string_literal: false

## substitution cipher
# the key is the number of "steps" in a rotation?
#
# encoding is rotation to the right (a..z is left..right)
# decoding is rotation to the left (wrap considered) 
#  
# simultaeneus iteration using enumerators
class Cipher

  NUMBER = [*'a'..'z'].zip(0...26).to_h.freeze
  LETTER = (0...26).zip([*'a'..'z']).to_h.freeze

  LEFT = :-
  RIGHT = :+
  attr_reader :key

  def initialize(key = generate_random_key)
    raise ArgumentError unless valid(key)

    @key = key
  end

  def decode(ciphertext)
    coder(ciphertext.each_char, key.each_char, LEFT)
  end

  def encode(plaintext)
    coder(plaintext.each_char, key.each_char, RIGHT)
  end

  private 

  def coder(text_enum, key_enum, direction)
    result = ''
    loop do 
      result << rotate(text_enum.next, key_enum.next, direction)
    end
    result
  end

  def rotate(letter, key, shifter)
    shifted_index = NUMBER[letter].method(shifter).call NUMBER[key]
    LETTER[shifted_index % 26]
  end

  def generate_random_key
    Array.new(100) { [*'a'..'z'].sample }.join
  end

  def valid(key)
    key =~ /\A[a-z]+\z/
  end
end