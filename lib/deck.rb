class Deck

  def initialize
    @index_card = -1
    @deck = []
    generate_deck
    shuffle
  end

  def give_card
    @deck[@index_card += 1]
  end

  def shuffle
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
