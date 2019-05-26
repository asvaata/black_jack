require_relative 'lib/user'
require_relative 'lib/dealer'
require_relative 'lib/deck'
require_relative 'lib/interface'
require_relative 'exceptions/to_many_cards'
require_relative 'exceptions/bust_cards'
require_relative 'exceptions/skip_move_dealer'

class Game

  attr_reader :user, :dealer, :name

  def initialize
    @interface = Interface.new
    @deck = Deck.new
    @dealer = Dealer.new
    @user = User.new
    @name = @interface.ask_name
    [@user, @dealer].each do |player|
      player.bank -= 10
      take_card(player, 2)
    end
    @interface.show_card(@user, @dealer)
    action
  end

  def restart_game
    @deck.shuffle
    @user.hand.new_game
    @dealer.hand.new_game
    [@user, @dealer].each do |player|
      player.bank -= 10
      take_card(player, 2)
    end
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
    @interface.add_card(@user.hand.sum_card, @user.hand.cards)
    action
  rescue BustCards => e
    @interface.show_points(e, @user.hand.sum_card, @user.hand.cards, @user.bank)
    end_game
  rescue ToManyCards => e
    @interface.show_message(e)
    action
  end

  def dealer_action
    @dealer.action(self)
    @interface.dealer_add_card
    action
  rescue SkipMoveDealer => e
    @interface.show_message(e.message)
    action
  rescue BustCards => e
    @interface.dealer_bust_cards(e.message, @dealer.bank)
    end_game
  end

  def end_game
    @interface.end_game
    restart_game
    @interface.show_card(@user, @dealer) if gets
    action
  end

  def open_card
    begin
      @dealer.action(self)
    rescue BustCards => e
      @interface.show_message(e)
      winner = @name
      @user.bank += 20
      @interface.open_card(@user, @dealer, @name, winner)
      end_game
    rescue SkipMoveDealer => e
      @interface.show_message(e)
      winner = if @dealer.hand.sum_card > @user.hand.sum_card
                 @dealer.bank += 20
                 :Dealer
               else
                 @user.bank += 20
                 @name
               end
      @interface.open_card(@user, @dealer, @name, winner)
      end_game
    end
  end

  def take_card(who, match)
    if who.is_a?(User)
      @user.add_card(@deck.give_card(match))
    elsif who.is_a?(Dealer)
      @dealer.add_card(@deck.give_card(match))
    end
  end
end

Game.new
