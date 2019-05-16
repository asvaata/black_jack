require_relative 'players'
require_relative '../exceptions/skip_move_dealer'
class Dealer < Players

  def action
    raise SkipMoveDealer.new 'Диллер пропускает ход' if self.cards.length == 3 || self.sum_card >= 17

    self.add_card
  end
end
