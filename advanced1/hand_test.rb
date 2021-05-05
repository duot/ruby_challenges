require 'minitest/autorun'
require_relative 'hand'

class HandTest < Minitest::Test
  def test_high_hand
    highcard = Hand.new %w(4S 5S 7H 8D JC)
    assert_equal highcard.rank, 10
  end

  def test_5kind
    skip # TODO implement
    hand = Hand.new %w[AS AS AS AS JOKER]
    assert_equal hand.rank, 1
  end

  def test_straight_flush_rank
    hand = Hand.new %w[JC TC 9C 8C 7C]
    assert_equal hand.rank, 2
  end

  def test_straight_rank
    hand = Hand.new %w[JD TC 9C 8C 7C]
    assert_equal hand.rank, 6
  end
end