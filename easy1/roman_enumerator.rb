
class RomanEnumerator
  R = %w[I V X L C D M].zip(0..6).to_h
  # {"I"=>0, "V"=>1, "X"=>2, "L"=>3, "C"=>4, "D"=>5, "M"=>6}

  PRIME_NUMERAL_VAL = {
    1000=>'M',
    500=>'D',
    100=>'C',
    50=>'L',
    10=>'X',
    5=>'V',
    1=>'I'
  }

  LEVELS = 1000, 500, 100, 50, 10, 5, 1

  NUMERALS = %w[I V X L C D M]

  def roman_enum
    sequencialp = lambda do |_, l2, l1|
      return false unless R[l2]
      R[l2] + 1 == R[l1] || R[l2] + 2 == R[l1]
    end

    threep = lambda do |l3, l2, l1|
      return false if l1.nil?
      l1 == l2 && l1 == l3
    end

    twop = lambda do |l3, l2, l1|
      l3 != l2 && l2 == l1
    end

    onep = lambda do |_, l2, l1|
     l2 != l1
    end

    grow = lambda { |n|
      l3 = n[-3]
      l2 = n[-2]
      last1 = n[-1]
      last_n = l3, l2, last1


      seq = sequencialp.call *last_n
      three = threep.call *last_n
      two = twop.call *last_n
      one = onep.call *last_n

      case
      when seq
        # pop 2, replace the last
        n = n[0..-3]
        n += last1
      when three
      fail 'error finding next symbol'
        # pop 4, add the next symbol
        n4 = n[-4]
        n = n[0..-5]
        if n4
          n += 'I'
          n += NUMERALS[R[n4] + 1]
        else
          n += 'IV'
        end
      when two
        # push 1
        n += last1
      when one
        # push 1
        n += 'I'
      else
        binding.pry
      end
    }

    Enumerator.new do |yielder|
      numerals = 'I'
      loop do
        yielder << numerals
        numerals = grow.call numerals
      end
    end
  end
end

__END__

  case n
  when 2..4
  when 6..9
  when 11..49
  when 51..99
  when 101..499
  when 501..999
  end

