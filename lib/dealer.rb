require_relative 'players'
class Dealer < Players

  def action(game)
    raise SkipMoveDealer, 'Диллер пропускает ход' if hand.enough_cards? || hand.enough_points?

    game.take_card(self, 1)

    raise BustCards, 'У диллера перебор' if hand.bust?
  end
end
