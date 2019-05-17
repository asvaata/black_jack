require_relative 'players'
require_relative '../exceptions/skip_move_dealer'
class Dealer < Players

  def action
    raise SkipMoveDealer, 'Диллер пропускает ход' if cards.length == 3 || sum_card >= 17

    add_card
  end
end
