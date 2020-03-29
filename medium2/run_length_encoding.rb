class RunLengthEncoding1
  def self.encode(text)
    rle = lambda do |chars_ar|
      size = chars_ar.size
      letter = chars_ar[0]
      size == 1 ? letter : size.to_s + letter
    end

    text.chars.slice_when { |left, right| left != right }.map(&rle).join
  end

  def self.decode(rle_encoded_text)
    expand = lambda do |encoding_segment|
      *numbers, letter = encoding_segment
      numbers.none? ? letter : letter * numbers.join.to_i
    end

    rle_encoded_text.chars
                    .slice_after(/(\d+\w)|\D/)
                    .map(&expand)
                    .join
  end
end

### WOW! This solution is by someone else
module RunLengthEncoding
  def self.encode(input)
    input.gsub(/(.)\1{1,}/) { |match| match.size.to_s + match[0] }
  end

  def self.decode(input)
    input.gsub(/\d+\D/) { |match| match[-1] * match.to_i }
  end
end
