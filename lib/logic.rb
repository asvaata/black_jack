require_relative 'user'
require_relative 'dealer'
require_relative 'card'
require_relative 'deck'
require_relative '../exceptions/to_many_cards'
require_relative '../exceptions/bust_cards'
require_relative '../exceptions/skip_move_dealer'

class Logic
  attr_reader :user, :dealer, :name

  def initialize(name)
    @deck = Deck.new
    @dealer = Dealer.new
    @user = User.new
    @name = name
    @user.bank -= 10
    @dealer.bank -= 10
    take_card(@dealer, 2)
    take_card(@user, 2)
  end

  def new_game
    @deck.shuffle
    @user.hand.new_game
    @dealer.hand.new_game
    @user.bank -= 10
    @dealer.bank -= 10
    take_card(@dealer, 2)
    take_card(@user, 2)
  end

  def dealer_action
    raise SkipMoveDealer, 'Диллер пропускает ход' if @dealer.hand.cards.length == 3 || @dealer.calc.sum_card >= 17

    take_card(@dealer, 1)

    raise BustCards, 'У диллера перебор' if @dealer.calc.sum_card > 21
  end

  def user_action
    raise ToManyCards, 'Вы не можете взять больше 3х карт' if @user.hand.cards.length == 3

    take_card(@user, 1)

    raise BustCards, 'У вас перебор' if @user.calc.sum_card > 21
  end

  def open_card
    winner = if @dealer.calc.sum_card > @user.calc.sum_card
               @dealer.bank += 20
               :Dealer
             else
               @user.bank += 20
               @name
             end
    return winner
  end

  def take_card(who, match)
    if who.is_a?(User)
      @user.add_card(@deck.give_card(match))
    elsif who.is_a?(Dealer)
      @dealer.add_card(@deck.give_card(match))
    end
  end
end
