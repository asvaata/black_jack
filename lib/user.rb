require_relative 'players'
class User < Players

  def action(game)
    return game.to_many_cards if hand.enough_cards?

    game.take_card(self, 1)

    game.user_bust if hand.bust?
  end
end
