require_relative 'card'
class Hand
  attr_reader :cards, :card

  def initialize
    @cards = []
    @card = Card.new
  end

  def add_card(*card)
    card.each do |value|
      @cards << value
    end
    @card.find_ace(@cards)
  end

  def enough_points?
    return true if @card.sum_card >= 17

    false
  end

  def bust?
    return true if @card.sum_card > 21

    false
  end

  def enough_cards?
    return true if @cards.length == 3

    false
  end

  def new_game
    @cards = []
  end
end
