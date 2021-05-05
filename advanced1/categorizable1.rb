
=begin
Categorizable
  cards.sort
high
  cards.last

kinds
  5, 4, 3, 2, none

straight aka sequential

category
  5kind or 
  straight flush or 
  4kind, fullhouse, flush, straight, 3kind, 2pair, 1pair, high card
=end
module Categorizable1
  # if equal category
  # compare by gategory rules
  # 1 if greater
  # -1 if less
  def <=>(other)
    comparator_val = rank <=> other.rank
    if comparator_val.zero?
      # grouped_by_card_rank <=> other.grouped_by_card_rank # if 0 also, then compare kicker
      group_ranks <=> other.group_ranks
    else  
      comparator_val
    end
  end

  def rank
    case
    # when rank1? then 1
    # when rank2? then 2
    # when rank3? then 3
    # when rank4? then 4
    # when rank5? then 5
    # when rank6? then 6
    # when rank7? then 7
    # when rank8? then 8
    # when rank9? then 9
    # when rank10? then 10
    when rank1? then 10
    when rank2? then 9
    when rank3? then 8
    when rank4? then 7
    when rank5? then 6
    when rank6? then 5
    when rank7? then 4
    when rank8? then 3
    when rank9? then 2
    when rank10? then 1
    else
      binding.pry
    end
  end

  def rank1? # 5kind
    kind == 4 && has_wildcard?
  end

  def rank2? # straight flush
    sequential? && suits_contained == 1
  end

  def rank3? # 4kind
    kind == 4 && grouped_by_card_rank.size == 2
  end

  def rank4? # fullhouse
    pair, triplet = grouped_by_card_rank
    pair && triplet && pair.size == 2 && triplet.size == 3 && grouped_by_card_rank.size == 2
  end

  def rank5? # flush
    suits_contained == 1  && grouped_by_card_rank.size == 5
  end

  def rank6? # straight
    sequential? && grouped_by_card_rank.size == 5
  end

  def rank7? # 3kind
    kind == 3 && grouped_by_card_rank.size == 3
  end

  def rank8? # 2pair
    one, pair1, pair2 = grouped_by_card_rank
    pair1.size == 2 && pair2.size == 2 && grouped_by_card_rank.size == 3
  end

  def rank9? # 1pair
    _a, _b, _c, pair = grouped_by_card_rank
    pair.size == 2 && grouped_by_card_rank.size == 4
  end

  def rank10? # high card
    grouped_by_card_rank.size == 5
  end

  def kind
    grouped_by_card_rank.last.size
  end

  def high
    grouped_by_card_rank.last.first.rank
  end

  def grouped_by_card_rank
    @grouped_by_rank ||= cards.group_by(&:rank).values.sort_by(&:size)
  end

  # cards are sequential if all the card[i + 1] is ranked card[i].rank + 1
  def sequential?
    first_four = cards.take 4
    first_four.each.with_index.all? do |card, index|
      card.rank + 1 == cards[index + 1].rank
    end
  end

  def suits_contained
    cards.map(&:suit).uniq.size
  end

  def has_wildcard?
    cards.any?(&:wildcard)
  end
end

module Categorizable
  # if equal category
  # compare by gategory rules
  def <=>(other)
    comparator_val = rank <=> other.rank
    if comparator_val.zero?
      group_ranks <=> other.group_ranks
    else  
      comparator_val
    end
  end

  def rank

  end

  def groups
    @grouped ||= cards.group_by(&:rank).values.sort_by(&:size)
  end

  # first is the high card
  def group_ranks
    groups. map { |group| group.first.rank }.reverse
  end

  def high_card
    group_ranks.first
  end
 end