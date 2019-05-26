require_relative 'hand'
class Players
  attr_accessor :bank, :hand

  def initialize
    @bank = 100
    @hand = Hand.new
  end

  def add_card(cards)
    @hand.add_card(*cards)
  end
end
