class Main
  require_relative 'class/deck'
  require_relative 'class/dealer'
  require_relative 'class/user'
  require_relative 'modules/exceptions'

  include Exceptions

  CHOOSE_ACTION = <<-MENU.freeze
  Выбирите действие:
  1.Пропустить
  2.Взять еще карту
  3.Открыть карты
  MENU

  ENTER_NAME = 'Введите ваше имя'.freeze
  ENTER_TO_CONTINUE = 'Нажмите любую клавишу чтобы продолжить...'.freeze
  DEALER_ADD_CARD = 'Диллер взял карту'.freeze
  END_GAME = 'Хотите попробывать еще?'.freeze

  def start_game
    puts ENTER_NAME
    @name = gets.chomp
    @user = User.new
    @dealer = Dealer.new
    @game_money = 0
    take_card
  end

  def take_card
    puts "Cумма карт #{@user.sum_card}, твои карты #{@user.cards}, ставка 10$"
    puts 'Карты диллера **, ставка 10$'
    @user.bank -= 10 && @dealer.bank -= 10
    puts ENTER_TO_CONTINUE
    action if gets
  end

  def action
    puts CHOOSE_ACTION
    user_input = gets.to_i

    case user_input
    when 1 then skip_action
    when 2 then add_card
    when 3 then open_card
    end
  end

  def dealer_action
    @dealer.action
    puts DEALER_ADD_CARD
    action
  rescue StandardError::SkipMoveDealer => e
    puts e.message
    action
  rescue StandardError::BustCards => e
    puts "У диллера #{e.message}, банк диллера составляет #{@dealer.bank}"
    end_game
  end

  def add_card
    @user.add_card
    puts "Cумма карт #{@user.sum_card}, твои карты #{@user.cards}"
    action
  rescue StandardError::BustCards => e
    puts "У вас #{e.message}, ваш банк составляет #{@user.bank}"
    end_game
  end

  def open_card
    winner = if @dealer.sum_card > @user.sum_card
               @dealer.bank += @game_money
               "Диллер"
             else
               @user.bank += @game_money
               @name
             end
    puts "Cумма карт игрока #{@name}: #{@user.sum_card}, карты #{@user.cards}"
    puts "Cумма карт игрока диллер: #{@dealer.sum_card}, карты #{@dealer.cards}"
    puts "Выйграл #{winner}"
    end_game
  end

  def end_game
    puts END_GAME
    puts ENTER_TO_CONTINUE
    @user.new_game && @dealer.new_game
    @game_money = 0
    take_card if gets
  end

  alias_method :skip_action, :dealer_action

  private

  attr_reader :dealer, :user, :name
end
