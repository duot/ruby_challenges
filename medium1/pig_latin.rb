require 'pry'
<<PIG
  consonant fronts
    alphabet, subtract vowels, add 'qu'
    ('a'..'z').to_a - %w|a e i o u| + ['qu']
  vowel fronts
    %|a e i o u| + ['xr', 'y']
PIG
# begining with vowels or xr or yt, exept u...q
class PigLatin
  def self.translate(string)
    vowel_prefix_p = ->(word) { word.match(/\A(?!\Au.*q\Z)([aeiou]|xr|yt)/) }

    vowel_to_front = lambda do |word|
      if vowel_prefix_p.call word
        word
      else
        vowel_to_front.call word.chars.rotate.join
      end
    end

    append_ay = ->(word) { word + 'ay' }
    string.split.map(&vowel_to_front >> append_ay).join ' '
  end
end

__END__

class PigLatin2
  def self.translate string
    words = string.split

    vowel_prefix_p = ->(word) { word.match /\A([aeiou]|xr|yt)/ }
    consonant_exception_p = ->(word) { word.match /\Aqu/ }

    vowel_to_front = ->word do
      if vowel_prefix_p.call word
        word
      elsif consonant_exception_p.call word
        vowel_to_front.call word.chars.rotate(2).join
      else
        vowel_to_front.call word.chars.rotate.join
      end
    end

    append_ay = ->word { word + 'ay' }

    words.map(&vowel_to_front).map(&append_ay).join ' '
  end
end

class PigLatin1
  # assumption: lower case
  def self.translate string
    words = string.split.map &:chars

    # wc is str_word.chars

    vowel_front_p =  ->(wc) do
      vowel_sounds = %w|a e i o u| # yt xr|
      vowel_sounds.include?(wc[0]) ||
        wc[0..1] == %w|x r| ||
        wc[0..1] == %w|y t|
    end

    consonant_exception_p = ->(wc) { wc[0..1] == %w|q u| }

    vowels_to_front = ->(wc) do
      if vowel_front_p.call(wc)
        wc
      elsif consonant_exception_p.call(wc)
        vowels_to_front.call wc.rotate(2)
      else
        vowels_to_front.call wc.rotate
      end
    end

    append_ay = ->(str) { str + 'ay' }

    vowel_front_words = words.map(&vowels_to_front).map &:join
    vowel_front_words.map(&append_ay).join ' '
  end
end
