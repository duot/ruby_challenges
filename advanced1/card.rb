
=begin
card
init(2charstr):void
  @rank
  @suit
rank
suit
to_i
  a => 1 TODO or 14?
  T => 10
  J -> 11
  Q -> 12
  K => 13
  A => 14
  2,3,4,5,6,7,8,9,10
<=>(other): -1 | 0 | 1
  to_i <=> other.to_i
=end
class Card
  attr_reader :rank, :suit, :face, :wildcard

  FACE_VALUE = {
    'T' => 10,
    'J' => 11,
    'Q' => 12,
    'K' => 13,
    'A' => 14
  }.freeze

  def initialize(face)
    @face = face
    if face == 'JOKER'
      @wildcard = true
    else
      rank, suit = face.split ''
      @ace = true if rank == 'A' 

      num = rank.to_i
      @rank = num.zero? ? FACE_VALUE[rank] : num
      @suit = suit
    end
  end

  def <=>(other)
    rank <=> other.rank
  end

  def to_s
    face
  end
end
