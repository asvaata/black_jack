require_relative '../game'
class Interface

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
    @game = Game.new
    @game.new_game(@name)
    show_card
  end

  def show_card
    puts "Сумма карт #{@game.user.calc.sum_card}," \
         "твои карты #{@game.user.hand.cards}, банк составляет #{@game.user.bank}"
    puts "Карты диллера **, банк составляет #{@game.dealer.bank}"
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
    @game.dealer_action
    puts DEALER_ADD_CARD
    action
  rescue SkipMoveDealer => e
    puts e.message
    action
  rescue BustCards => e
    puts "#{e.message}, банк диллера составляет #{@game.dealer.bank}"
    end_game
  end

  def add_card
    @game.user_action
    puts "Сумма карт #{@game.user.calc.sum_card}, твои карты #{@game.user.hand.cards}"
    action
  rescue BustCards => e
    puts "#{e.message}, сумма карт: #{@game.user.calc.sum_card}," \
         "ваши карты #{@game.user.hand.cards}, ваш банк составляет #{@game.user.bank}"
    end_game
  rescue ToManyCards => e
    puts e.message
    action
  end

  def open_card
    begin
    @game.dealer_action
    rescue SkipMoveDealer, BustCards => e
      puts e.message
    ensure
    winner = @game.open_card
    puts "Выйграл #{winner}"
    puts "Сумма карт игрока #{@name}: #{@game.user.calc.sum_card}," \
         "карты #{@game.user.hand.cards}, банк #{@game.user.bank}"
    puts "Сумма карт игрока диллер: #{@game.dealer.calc.sum_card}," \
         "карты #{@game.dealer.hand.cards}, банк #{@game.dealer.bank}"
    end_game
    end
  end

  def end_game
    puts END_GAME
    puts ENTER_TO_CONTINUE
    @game.restart_game
    show_card if gets
  end

  def wrong_input
    puts WRONG_INPUT
    puts ENTER_TO_CONTINUE
    action if gets
  end

  alias skip_action dealer_action
end
