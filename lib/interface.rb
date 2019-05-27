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
  USER_BUST_CARD = 'У вас перебор'.freeze
  DEALER_SKIP_MOVE = 'Диллер пропускает ход'.freeze
  TO_MANY_CARDS = 'Вы не можете взять больше 3х карт'.freeze
  END_GAME = 'Хотите попробывать еще?'.freeze
  WRONG_INPUT = 'Вы ввели не правильное значение'.freeze

  def ask_name
    puts ENTER_NAME
    name = gets.chomp
    name
  end

  def show_card(user, dealer)
    puts "Сумма карт #{user.hand.card.sum_card}," \
         "твои карты #{user.hand.cards}, банк составляет #{user.bank}"
    puts "Карты диллера **, банк составляет #{dealer.bank}"
    puts ENTER_TO_CONTINUE
    return if gets
  end

  def choice_action
    puts CHOOSE_ACTION
    user_input = gets.to_i

    user_input
  end

  def add_card(sum_card, cards)
    puts "Сумма карт #{sum_card}, твои карты #{cards}"
  end

  def dealer_add_card
    puts DEALER_ADD_CARD
  end

  def show_message(msg)
    puts msg
  end

  def show_points(msg, sum_card, cards, bank)
    puts "#{msg}, сумма карт: #{sum_card}," \
         "ваши карты #{cards}, ваш банк составляет #{bank}"
  end

  def dealer_bust_cards(bank)
    puts "У диллера перебор, банк диллера составляет #{bank}"
  end

  def open_card(user, dealer, name, winner)
    puts "Выйграл #{winner}"
    puts "Сумма карт игрока #{name}: #{user.hand.card.sum_card}," \
         "карты #{user.hand.cards}, банк #{user.bank}"
    puts "Сумма карт игрока диллер: #{dealer.hand.card.sum_card}," \
         "карты #{dealer.hand.cards}, банк #{dealer.bank}"
  end

  def bust_points
    puts USER_BUST_CARD
  end

  def to_many_cards
    puts TO_MANY_CARDS
  end

  def skip_move_dealer
    puts DEALER_SKIP_MOVE
  end

  def end_game
    puts END_GAME
    puts ENTER_TO_CONTINUE
  end

  def wrong_input
    puts WRONG_INPUT
    puts ENTER_TO_CONTINUE
  end
end
