require_relative 'players'
class User < Players

  def action(game)
    raise ToManyCards, 'Вы не можете взять больше 3х карт' if hand.enough_cards?

    game.take_card(self, 1)

    raise BustCards, 'У вас перебор' if hand.bust?
  end
end
