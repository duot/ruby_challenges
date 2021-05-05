
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
module Categorizable
  # if equal category
  # compare by gategory rules
  def <=>(other)
    category_comp = rank <=> other.rank
    if category_comp == 0
      grouped_card_ranks <=> other.grouped_card_ranks
    else  
      category_comp
    end
  end

  def rank
    case 
    when five_of_a_kind? then 10
    when straight_flush? then 9
    when four_of_a_kind? then 8
    when full_house? then 7
    when flush? then 6
    when straight?, straight_to_5? then 5
    when three_of_a_kind? then 4
    when two_pair? then 3
    when one_pair? then 2
    else # when high_card? then 1
      1
    end
  end

  def five_of_a_kind?
    four_of_a_kind? && has_wildcard?
  end

  def straight_flush?
    straight? && flush?
  end

  def straight?
    first_four = sorted_cards.take 4
    first_four.each.with_index.all? do |card, index|
      card.rank + 1 == sorted_cards[index + 1].rank
    end
  end

  def straight_to_5?
    pattern = [2, 3, 4, 5, 14]
    sorted_cards.map(&:rank) == pattern
  end

  def flush?
    suit = sorted_cards.first.suit
    sorted_cards.all? { |card| card.suit == suit }
  end

  def four_of_a_kind?
    kind == 4
  end

  def full_house?
    groups.size == 2 && groups.last.size == 3
  end

  def three_of_a_kind?
    kind == 3
  end

  def two_pair?
    _one, pair = groups
    pair.size == 2 && one_pair?
  end

  def one_pair?
    *_one, pair = groups
    pair.size == 2
  end

  def groups
    @grouped ||= sorted_cards.group_by(&:rank).values.sort_by(&:size)
  end

  # first is the high card
  def grouped_card_ranks
    groups.map { |group| group.first.rank }.reverse
  end

  def high_card
    grouped_card_ranks.first
  end

  def kind
    groups.last.size
  end

  def has_wildcard?
    sorted_cards.any?(&:wildcard)
  end
 end