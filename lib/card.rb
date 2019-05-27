class Card
  attr_reader :cards, :sum_card, :ace

  REGEXP = /^[KQJ]$/.freeze

  def find_ace(cards)
    @cards = []
    @sum_card = 0
    @cards = cards
    cards.each do |card|
      next unless card[0..-2] == 'A'

      @ace = card
      cards.delete(card)
      cards << @ace
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
end
