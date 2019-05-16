require_relative 'deck'
require_relative '../exceptions/bust_cards'
class Players
  attr_accessor :bank, :cards, :sum_card, :ace

  def initialize
    @deck = Deck.new
    @bank = 100
    @cards = @deck.give_card, @deck.give_card
    @sum_card = 0
    find_ace
  end

  def new_game
    @cards = @deck.give_card, @deck.give_card
    find_ace
  end

  def find_ace
    @sum_card = 0
    @cards.each do |card|
      if card[0..-2] == 'A'
        @ace = card
        @cards.delete(card)
        @cards << @ace
      end
    end
    calculate_sum_card
  end

  def calculate_sum_card
    @cards.each do |card|
      if card[0..-2].to_i > 0
        @sum_card += card[0..-2].to_i
      elsif card == @ace
        if (@sum_card + 11) > 21
          @sum_card += 1
        else
          @sum_card += 11
        end
      elsif card[0..-2].to_i == 0
        case card[0..-2]
        when 'K' then @sum_card += 10
        when 'Q' then @sum_card += 10
        when 'J' then @sum_card += 10
        end
      end
    end
  end

  def add_card
    @cards << @deck.give_card
    find_ace
    raise BustCards.new 'перебор' if @sum_card > 21
  end

  private

  attr_reader :deck
end
