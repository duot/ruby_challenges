require 'pry'
# We encode by writing in a zigzag along the rails
# zigzag, the next letter is on the the next rail
# next is positive increments until rails == n
# then switch to decrementing until rails == 1
          
# decoding
# zigzag is first class
# overwrite the next ? on the first rail
# then continue on the next rail

class ZigZag 
  def self.z(n_rails, chars_enum)
    if n_rails == 1
      return Enumerator.new do |y|
        loop do
          char = chars_enum.next
          y << [char, 1]
        end
      end
    end

    n = 1
    downwards = true

    Enumerator.new do |y|
      loop do
        char = chars_enum.next
        y << [char, n]

        if downwards
          n += 1
          n = 1 if n == n_rails
        else
        end

        i = n_rails - (n % n_rails)

        if i == n_rails
          n = 1
        end
      end
    end
  end
end

class RailFenceCipher
  class Line
    def initialize(n_rails, chars_enum)
      @chars = []

      loop do
        # for 1.. n_rails
        @chars << chars_enum.next
      end
    end

    def to_s
      @chars.join
    end
  end

  class Down < Line
  end

  class Up < Line
    
  end

  class Z
    def initialize(n_rails)
    end

    def fill
    end

    def zig
    end
  end
end

class RailFenceCipher
  class << self
    def encode(plaintext, n_rails)
    end

    def decode(ciphertext, n_rails)
      cipher_enum = ciphertext.chars.to_enum
      alternate = [true, false].cycle
      lines = []
      loop do
        if alternate.next 
          lines << Down.new(n_rails, cipher_enum)
        else
          lines << Up.new(n_rails, cipher_enum)
        end
      end

      lines.join
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  z = ZigZag.z(2, 'abc'.chars.to_enum)
  binding.pry
  z
end