class Deck

  def initialize
    @deck = []
    generate_deck
    shuffle
  end

  def give_card(match)
    if match == 1
      return @deck[@index_card += 1]
    else
      return @deck[@index_card += 1], @deck[@index_card += 1]
    end
  end

  def shuffle
    @index_card = -1
    @deck.shuffle!
  end

  private

  def generate_deck
    (2..10).each do |value|
      @deck << "#{value}♠"
      @deck << "#{value}♥"
      @deck << "#{value}♣"
      @deck << "#{value}♦"
    end

    %w[A K Q J].each do |value|
      @deck << "#{value}♠"
      @deck << "#{value}♥"
      @deck << "#{value}♣"
      @deck << "#{value}♦"
    end
  end
end
