class Hand
  attr_reader :cards

  def initialize
    @cards = []
  end

  def add_card(*card)
    card.each do |value|
      @cards << value
    end
  end

  def new_game
    @cards = []
  end
end
