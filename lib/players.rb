require_relative 'deck'
require_relative '../exceptions/bust_cards'
require_relative '../exceptions/to_many_cards'
class Players
  attr_accessor :bank, :cards, :sum_card, :ace

  REGEXP = /^[KQJ]$/.freeze

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
      next unless card[0..-2] == 'A'

      @ace = card
      @cards.delete(card)
      @cards << @ace
    end
    calculate_sum_card
  end

  def calculate_sum_card
    @cards.each do |card|
      if card[0..-2].to_i > 0
        @sum_card += card[0..-2].to_i
      elsif card == @ace
        return @sum_card += 1 if (@sum_card + 11) > 21

        return @sum_card += 11
      elsif card[0..-2] =~ REGEXP
        @sum_card += 10
      end
    end
  end

  def add_card
    @cards << @deck.give_card
    find_ace
    raise BustCards, 'Перебор' if @sum_card > 21
    raise ToManyCards, 'У вас уже 3 карты' if @cards.length > 3
  end

  private

  attr_reader :deck
end
