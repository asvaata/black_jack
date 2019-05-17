class Main
  require_relative 'lib/deck'
  require_relative 'lib/dealer'
  require_relative 'lib/user'

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
  WRONG_INPUT = 'Вы ввели не правильное значение'.freeze

  def start_game
    puts ENTER_NAME
    @name = gets.chomp
    @user = User.new
    @dealer = Dealer.new
    @game_money = 0
    take_card
  end

  def take_card
    puts "Сумма карт #{@user.sum_card}, твои карты #{@user.cards}, банк составляет #{@user.bank}"
    puts "Карты диллера **, банк составляет #{@user.bank}"
    @user.bank -= 10
    @dealer.bank -= 10
    @game_money = 20
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
    else
      wrong_input
    end
  end

  def dealer_action
    @dealer.action
    puts DEALER_ADD_CARD
    action
  rescue SkipMoveDealer => e
    puts e.message
    action
  rescue BustCards => e
    puts "У диллера #{e.message}, банк диллера составляет #{@dealer.bank}"
    end_game
  end

  def add_card
    @user.add_card
    puts "Сумма карт #{@user.sum_card}, твои карты #{@user.cards}"
    action
  rescue BustCards => e
    puts "У вас #{e.message}, сумма карт: #{@user.sum_card}, ваши карты #{@user.cards}, ваш банк составляет #{@user.bank}"
    end_game
  rescue ToManyCards => e
    puts e.message
    action
  end

  def open_card
    begin
    @dealer.action
    rescue SkipMoveDealer, BustCards => e
      puts e.message
    ensure
    winner = if @dealer.sum_card > @user.sum_card
               @dealer.bank += @game_money
               :Dealer
             else
               @user.bank += @game_money
               @name
             end
    puts "Выйграл #{winner}"
    puts "Сумма карт игрока #{@name}: #{@user.sum_card}, карты #{@user.cards}, банк #{@user.bank}"
    puts "Сумма карт игрока диллер: #{@dealer.sum_card}, карты #{@dealer.cards}, банк #{@dealer.bank}"
    end_game
    end
  end

  def end_game
    puts END_GAME
    puts ENTER_TO_CONTINUE
    @user.new_game && @dealer.new_game
    @game_money = 0
    take_card if gets
  end

  def wrong_input
    puts WRONG_INPUT
    puts ENTER_TO_CONTINUE
    action if gets
  end

  alias skip_action dealer_action

  private

  attr_reader :dealer, :user, :name
end
