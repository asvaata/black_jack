require_relative 'card'
class Hand
  attr_reader :cards, :calc

  def initialize
    @cards = []
  end

  def add_card(*card)
    card.each do |value|
      @cards << value
    end
    @calc = Card.new(@cards)
  end

  def enough_points?
    return true if calc.sum_card >= 17

    false
  end

  def bust?
    return true if calc.sum_card > 21

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
