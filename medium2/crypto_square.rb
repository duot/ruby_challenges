# frozen_string_literal: true

# it forms a square with normalized letters aligned row by row.
# the cipher is made from the columns formed
class Crypto
  def initialize(input_text)
    @text = input_text
  end

  def normalize_plaintext
    @text.downcase.delete('^a-z0-9')
  end

  def size
    @size ||= Math.sqrt(normalize_plaintext.size).ceil
  end

  def plaintext_segments
    normalize_plaintext.chars.each_slice(size).map(&:join)
  end

  def ciphertext
    cipher_segments.join
  end

  def normalize_ciphertext
    cipher_segments.join ' '
  end

  private

  def cipher_segments
    cipher = []
    0.upto(size - 1) do |index|
      segment_nth = proc { |seg| seg[index] }
      cipher << plaintext_segments.map(&segment_nth)
    end
    cipher.map(&:join)
  end
end
