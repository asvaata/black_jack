require_relative 'lib/logic'
class Main

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
    @logic = Logic.new(@name)
    show_card
  end

  def show_card
    puts "Сумма карт #{@logic.user.calc.sum_card}," \
         "твои карты #{@logic.user.hand.cards}, банк составляет #{@logic.user.bank}"
    puts "Карты диллера **, банк составляет #{@logic.dealer.bank}"
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
    @logic.dealer_action
    puts DEALER_ADD_CARD
    action
  rescue SkipMoveDealer => e
    puts e.message
    action
  rescue BustCards => e
    puts "#{e.message}, банк диллера составляет #{@logic.dealer.bank}"
    end_game
  end

  def add_card
    @logic.user_action
    puts "Сумма карт #{@logic.user.calc.sum_card}, твои карты #{@logic.user.hand.cards}"
    action
  rescue BustCards => e
    puts "#{e.message}, сумма карт: #{@logic.user.calc.sum_card}," \
         "ваши карты #{@logic.user.hand.cards}, ваш банк составляет #{@logic.user.bank}"
    end_game
  rescue ToManyCards => e
    puts e.message
    action
  end

  def open_card
    begin
    @logic.dealer_action
    rescue SkipMoveDealer, BustCards => e
      puts e.message
    ensure
    winner = @logic.open_card
    puts "Выйграл #{winner}"
    puts "Сумма карт игрока #{@name}: #{@logic.user.calc.sum_card}," \
         "карты #{@logic.user.hand.cards}, банк #{@logic.user.bank}"
    puts "Сумма карт игрока диллер: #{@logic.dealer.calc.sum_card}," \
         "карты #{@logic.dealer.hand.cards}, банк #{@logic.dealer.bank}"
    end_game
    end
  end

  def end_game
    puts END_GAME
    puts ENTER_TO_CONTINUE
    @logic.new_game
    show_card if gets
  end

  def wrong_input
    puts WRONG_INPUT
    puts ENTER_TO_CONTINUE
    action if gets
  end

  alias skip_action dealer_action
end
