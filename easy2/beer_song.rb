# frozen_string_literal: false

require 'pry'
class BeerSong
  def initialize
    @plural = Hash.new('s')
    @plural[1] = ''

    @take = Hash.new 'Take one down and pass it around, '
    @take[1] = 'Take it down and pass it around, '
    @take[0] = 'Go to the store and buy some more, '

    # 0                              2                   4    5
    @struct = [
      nil, ' of beer on the wall, ', nil, " of beer.\n", nil, nil,
      " of beer on the wall.\n"
    ]
  end

  def verse n
    # transformations(n).call Array.new(@struct)
    transformations(n).call @struct
  end

  def lyrics
    verses 99, 0
  end

  def verses from, to
    from.downto(to).map(&method(:verse)).join "\n"
  end

  private

  attr_reader :plural, :take

  def pluralizer_lambda n
    lambda { |strc|
      strc.tap do
        strc[0] = bottle n
        strc[2] = bottle n
        strc[5] = bottle(n - 1)
      end
    }
  end

  def transformations n
    pluralizer  = pluralizer_lambda n
    capitalizer = ->(strc) { strc.tap { strc[0] = strc[0].capitalize } }
    taker       = ->(strc) { strc.tap { strc[4] = take[n] } }
    joiner      = ->(strc) { strc.join }
    # highlight
    pluralizer >> capitalizer >> taker >> joiner
    # endhighlight
  end

  def bottle b
    "#{more b} bottle#{plural[b]}"
  end

  def more m
    ['no more', m, 99][m <=> 0]
  end
end

# Beer song implement using fuctional composition,
#   lambdas, and struct
class BeerSong4
  Lyric = Struct.new(
    :n, :bottle1, :word1, :bottle2, :word2, :take1, :bottle3, :word3
  )

  def initialize
    @plural = Hash.new('s')
    @plural[1] = ''

    @take = Hash.new 'Take one down and pass it around, '
    @take[1] = 'Take it down and pass it around, '
    @take[0] = 'Go to the store and buy some more, '
    @struct = Lyric.new(
      nil,
      nil,
      ' of beer on the wall, ',
      nil,
      " of beer.\n",
      nil,
      nil,
      " of beer on the wall.\n"
    )
  end

  def verse n
    struct = @struct
    struct[0] = n

    # hightlight
    transformations = method(:pluralizer) >>
                      method(:capitalizer) >>
                      method(:taker) >>
                      method(:joiner)

    transformations.call struct
    # endhighlight
  end

  def lyrics
    verses 99, 0
  end

  def verses from, to
    from.downto(to).map(&method(:verse)).join "\n"
  end

  private

  attr_reader :plural, :take

  def pluralizer strc
    strc[1] = bottle strc[0]
    strc[3] = bottle strc[0]
    strc[6] = bottle(strc[0] - 1)
    strc
  end

  def joiner strc
    strc.values[1..-1].join
  end

  def capitalizer strc
    strc[1].to_s.capitalize!
    strc
  end

  def taker strc
    strc[5] = take[strc[0]]
    strc
  end

  def bottle b
    "#{more b} bottle#{plural[b]}"
  end

  def more m
    ['no more', m, 99][m <=> 0]
  end
end

##########################################################
class BeerSong3
  def initialize
    @plural = Hash.new('s')
    @plural[1] = ''

    @take = Hash.new 'Take one down and pass it around, '
    @take[1] = 'Take it down and pass it around, '
    @take[0] = 'Go to the store and buy some more, '

    # 0                              2                   4    5
    @struct = [
      nil, ' of beer on the wall, ', nil, " of beer.\n", nil, nil,
      " of beer on the wall.\n"
    ]
  end

  def verse n
    pluralizer = lambda { |strc|
      strc.tap {
        strc[0] = bottle n
        strc[2] = bottle n
        strc[5] = bottle(n - 1)
      }
    }

    capitalizer = ->(strc) { strc.tap { strc[0].capitalize! } }

    taker = ->(strc) { strc.tap { strc[4] = take[n] } }

    joiner = ->(strc) { strc.join }
    # hightlight
    transformations = pluralizer >> capitalizer >> taker >> joiner
    transformations.call struct
    # endhighlight
  end

  def lyrics
    verses 99, 0
  end

  def verses from, to
    from.downto(to).map(&method(:verse)).join "\n"
  end

  private

  attr_reader :plural, :take, :struct

  def bottle b
    "#{more b} bottle#{plural[b]}"
  end

  def more m
    ['no more', m, 99][m <=> 0]
  end
end

if __FILE__ == $0
  require 'benchmark'
  n = 500
  Benchmark.bmbm do |x|
    x.report('array') { n.times { BeerSong3.new.lyrics } }
    x.report('Struct') { n.times { BeerSong4.new.lyrics } }
    x.report('array, methods') { n.times { BeerSong5.new.lyrics } }

  end
end

__END__

class BeerSong_2
  def lyrics
    verses 99, 0
  end

  def verses from, to
    (to..from).to_a.reverse.map(&method(:verse)).join ?\n
  end

  def verse n
    more = ->(n){ n == 0 ? 'no more' : "#{n}" }
    s = ->(n){ n == 1 ? '' : 's' }
    it = -> { n == 1 ? 'it' : 'one' }
    take = -> { n == 0 ? 'Go to the store and buy some more' : "Take #{it.call} down and pass it around" }
    wall = ->(m){ n == 0 ? 99 : more.call(n - 1) }

    "#{more.call(n).capitalize} bottle#{s.call n} of beer on the wall, #{more.call n} bottle#{s.call n} of beer.\n" \
    "#{take.call}, #{wall.call n} bottle#{s.call(n - 1)} of beer on the wall.\n"
  end
end

class BeerSong_1
  def lyrics
    verses 99, 0
  end

  def verses from, to
    (to..from).to_a.reverse.map(&method(:verse)).join ?\n
  end

  def verse n
    if n == 0
      "No more bottles of beer on the wall, no more bottles of beer.\n" \
      "Go to the store and buy some more, 99 bottles of beer on the wall.\n"
    elsif n == 1
      "1 bottle of beer on the wall, 1 bottle of beer.\n" \
      "Take it down and pass it around, no more bottles of beer on the wall.\n"
    else
      "#{n} bottles of beer on the wall, #{n} bottles of beer.\n" \
      "Take one down and pass it around, #{n - 1} bottle#{n == 2 ? '': 's'} of beer on the wall.\n"
    end
  end
end
