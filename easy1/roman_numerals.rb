require 'pry'

module Roman_5
  ROMAN = {
    1000=>"M", 900=>"CM", 500=>"D", 400=>"CD", 100=>"C", 90=>"XC",
    50=>"L", 40=>"XL", 10=>"X", 9=>"IX", 5=>"V", 4=>"IV", 1=>"I"
  }.freeze

  def to_roman
    raise RuntimeError 'cant handle 0 or negative' if self < 1

    return ROMAN[self] if ROMAN[self]

    rem = self
    numerals = ''

    ROMAN.keys.each do |value|
      quot, rem = rem.divmod value # remainder, quotient
      next if quot == 0
      numerals << ROMAN[value] * quot
    end

    numerals
  end
end

module Roman_45
  ROMAN = {
    1000=>"M", 900=>"CM", 500=>"D", 400=>"CD", 100=>"C", 90=>"XC",
    50=>"L", 40=>"XL", 10=>"X", 9=>"IX", 5=>"V", 4=>"IV", 1=>"I"
  }.freeze

  def to_roman
    raise RuntimeError 'cant handle 0 or negative' if self < 1

    numerals = ROMAN[self]
    return numerals if numerals

    rem = self
    numerals = ''

    ROMAN.keys.each do |value|
      quot, rem = rem.divmod value # remainder, quotient
      next if quot == 0
      numerals << ROMAN[value] * quot
    end

    numerals
  end
end
#           user     system      total        real
#roman   1.236785   0.000000   1.236785 (  1.236816)

#            user     system      total        real
#roman   1.173027   0.000000   1.173027 (  1.173035)

#            user     system      total        real
#roman   1.177684   0.004043   1.181727 (  1.182801)

#            user     system      total        real
#roman   1.784018   0.000005   1.784023 (  1.784049)

module Roman_4 # bob rode's
  def to_roman
    roman_numerals = {
      M:1000, CM:900, D:500, CD:400, C:100, XC:90,
      L:50, XL:40, X:10, IX:9, V:5, IV:4, I:1
    }

    remainder = self

    roman_numerals.each_with_object('') do |(k, v), roman_numeral|
      roman_numeral << k.to_s * (remainder / v) # can be empty string * any number. brilliant
      remainder %= v
    end
  end
end
#            user     system      total        real
#roman   2.089399   0.000000   2.089399 (  2.089433)

module Roman_3
  ROMAN = {
    1=>'I',
    4=>'IV',
    5=>'V',
    9=>'IX',
    10=>'X',
    40=>'XL',
    50=>'L',
    90=>'XC',
    100=>'C',
    400=>'CD',
    500=>'D',
    900=>'CM',
    1000=>'M'
  }

  def to_roman
    numeral = ROMAN[self]
    return numeral if numeral
    err = 'cant handle zero or negative'
    raise RuntimeError err if self < 1


    f = factorize self
    numerals = f.map { |i| ROMAN[i] }
    numerals.join
  end

  FACTORS = 1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1

  # array of roman numeral factors
  def factorize n, factors = []
    rem = 0
    FACTORS.each { |f|
      quot, rem = n.divmod f
      next if quot == 0

      quot.times { factors << f }
      break
    }

    if rem == 0
      factors
    else
      factorize rem, factors
    end
  end
end
#            user     system      total        real
#roman   2.260038   0.000002   2.260040 (  2.260029)


#Integer.include Roman_3

module Roman_2
  ROMAN = {
      1000  => "M",
      900   => "CM",
      500   => "D",
      400   => "CD",
      100   => "C",
      90    => "XC",
      50    => "L",
      40    => "XL",
      10    => "X",
      9     => "IX",
      5     => "V",
      4     => "IV",
      1     => "I"
  }.freeze

  def to_roman
    numeral = ROMAN[self]
    return numeral if numeral
    err = 'cant handle zero or negative'
    raise RuntimeError err if self < 1

    place_enum = ROMAN.to_enum
    place = place_enum.next
    numeral = ''
    n = self

    loop do
      break numeral if n == 0
      if place[0] > n
        place = place_enum.next
      else
        n -= place[0]
        numeral << place[1]
      end
    end
  end
end

#Integer.include Roman_2
#            user     system      total        real
#roman   3.584514   1.484215   5.068729 (  5.068852)


class Integer_1
  ROMAN = {
    1=>'I',
    4=>'IV',
    5=>'V',
    9=>'IX',
    10=>'X',
    40=>'XL',
    50=>'L',
    90=>'XC',
    100=>'C',
    400=>'CD',
    500=>'D',
    900=>'CM',
    1000=>'M'
  }

  def to_roman
    numeral = ROMAN[self]
    return numeral if numeral
    err = 'cant handle zero or negative'
    raise RuntimeError err if self < 1


    f = factorize self
    numerals = f.map { |i| ROMAN[i] }
    numerals.join
  end

  FACTORS = 1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1

  # array of roman numeral factors
  def factorize n, factors = []
    rem = 0
    FACTORS.each { |f|
      quot, rem = n.divmod f
      next if quot == 0

      quot.times { factors << f }
      break
    }

    if rem == 0
      factors
    else
      factorize rem, factors
    end
  end
end

#            user     system      total        real
#roman   2.257345   0.000000   2.257345 (  2.257404)


Integer.include Roman_5

if __FILE__ == $0
  require 'benchmark'
  #p 0.to_roman
  #p -1.to_roman
  p (1..100).map &:to_roman

  n = 200
  ar = (1..3000).to_a
  Benchmark.bmbm do |x|
    x.report('roman') { n.times { ar.map &:to_roman }}
  end

end
