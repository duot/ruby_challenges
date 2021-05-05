require_relative 'categorizable'
require_relative 'card'

class Hand
  include Comparable
  include Categorizable

  attr_reader :sorted_cards, :notation

  def initialize(notation)
    @notation = notation
    @sorted_cards = notation.map { |face| Card.new face }.sort
  end

  def to_s
    notation.join
  end
end
