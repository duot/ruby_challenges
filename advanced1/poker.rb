require 'pry'
require_relative 'hand'

=begin

algorithm to pick the best hand from the hands
  [hand, hand]-> [hand]
              -> [["2S", "2H", ...]]

  hand is 5 cards
  card is 2 char string: rank + suit

  1 is better than other if:
    this order 
      5kind
      straight flush
      4kind
      fullhouse
        triplet, pair
      flush
        same suits
      straight
        5sequential
          ace to 5
          10 to ace
      3kind
      2pair
      2pair
        rank by pair
          if same, rank by kicker
            kicker is the highest of the 3
      highcard

    or within the same category

  flush
    same suit

  sort hand by category
    if in the same category, sort by that category sorting rules
    if different category,
      sort by category ranking

category
  hand.category
=end
class Poker
  attr_reader :hands

  def initialize(hands_notation)
    @hands = hands_notation.map { |notation| Hand.new(notation) }
  end

  def best_hand
    sorted = @hands.sort
    best_hands = []

    loop do 
      best_hands.unshift sorted.pop
      comp = sorted.last <=> best_hands.last
      break if comp != 0
    end

    best_hands.map { |hand| hand.notation }
  end
end

if __FILE__ == $PROGRAM_NAME
  high_of_jack = %w(4S 5S 7H 8D JC)
  p= Poker.new [high_of_jack]
  binding.pry
end