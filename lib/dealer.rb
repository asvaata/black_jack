require_relative 'players'
class Dealer < Players

  def action(game)
    return game.dealer_skip if hand.enough_cards? || hand.enough_points?

    game.take_card(self, 1)

    game.dealer_bust if hand.bust?
  end
end
