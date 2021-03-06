require_relative 'lib/user'
require_relative 'lib/dealer'
require_relative 'lib/deck'
require_relative 'lib/interface'

class Game

  attr_reader :user, :dealer, :name

  def initialize
    @interface = Interface.new
    @deck = Deck.new
    @dealer = Dealer.new
    @user = User.new
    start
  end

  def start
    @name = @interface.ask_name
    each_methods
    @interface.show_card(@user, @dealer)
    action
  end

  def each_methods
    [@user, @dealer].each do |player|
      player.bank -= 10
      take_card(player, 2)
    end
  end

  def restart_game
    @deck.shuffle
    @user.hand.new_game
    @dealer.hand.new_game
    each_methods
  end

  def action
    user_input = @interface.choice_action

    case user_input
    when 1 then dealer_action
    when 2 then add_card
    when 3 then open_card
    else
      @interface.wrong_input
      action if gets
    end
  end

  def add_card
    @user.action(self)
    @interface.add_card(@user.hand.card.sum_card, @user.hand.cards)
    action
  end

  def dealer_action
    @dealer.action(self)
    @interface.dealer_add_card
    action
  end

  def end_game(winner)
    @interface.open_card(@user, @dealer, @name, winner)
    @interface.end_game
    restart_game
    @interface.show_card(@user, @dealer) if gets
    action
  end

  def open_card
    @dealer.action(self)
    winner = if @dealer.hand.card.sum_card > @user.hand.card.sum_card
               @dealer.bank += 20
               :Dealer
             else
               @user.bank += 20
               @name
             end
    end_game(winner)
  end

  def take_card(who, match)
    if who.is_a?(User)
      @user.add_card(@deck.give_card(match))
    elsif who.is_a?(Dealer)
      @dealer.add_card(@deck.give_card(match))
    end
  end

  def dealer_skip
    @interface.skip_move_dealer
  end

  def dealer_bust
    @interface.dealer_bust_cards(@dealer.bank)
    @user.bank += 20
    end_game(@name)
  end

  def to_many_cards
    @interface.to_many_cards
    action
  end

  def user_bust
    @interface.bust_points
    @dealer += 20
    end_game(:Dealer)
  end
end

Game.new
