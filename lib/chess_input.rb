module Alphanumeric_Key
  ALPHA_TO_X = { a: 0, b: 1, c: 2, d: 3, e: 4, f: 5, g: 6, h: 7 }.freeze
end

include Alphanumeric_Key
require "./lib/chess_pieces.rb"
require "./lib/chess_moves.rb"

class ChessInput
  attr_reader :win

  def initialize(win)
    @from_alpha = from_alpha
    @to_alpha = to_alpha
    @win = win
    reset_position
  end

  def reset_position
    win.setpos(0, 2)
  end

  def move(color, board)
    move_object = nil
    loop do
      move_object = get_move_object(color, board)
      # puts "move_object: #{move_object.piece.info_string}, #{move_object.from_coord.value_array}, #{move_object.to_coord.value_array}"
      win.clear
      reset_position
      win.addstr(
        "#{move_object.coordinates_array}, #{move_object.legal?}, #{move_object.piece.info_string}"
      )
      win.refresh
      sleep 3
      break if move_object.legal?
      illegal_move_message
    end

    move_object
  end

  def get_move_object(color, board)
    translator = MoveTranslator.new(board)
    self.from_alpha = alpha_input(color, "from")
    self.to_alpha = alpha_input(color, "to")
    translator.alpha_to_move(color, from_alpha, to_alpha)
  end

  def alpha_input(color, to_from_string)
    square_choice = nil
    loop do
      win.clear
      reset_position
      win.addstr(
        "#{color.name.capitalize}, input the square you will move #{to_from_string} in algebraic notation (ex: e2):"
      )
      win.refresh
      square_choice = win.getstr
      break if valid_alpha?(square_choice)
      invalid_alpha_message(square_choice)
    end
    square_choice.downcase
  end

  def promotion_option
    loop do
      win.clear
      reset_position
      win.addstr(
        "Please input the letter of the piece you would like to promote to (Q, R, N, or B):"
      )
      win.refresh
      promotion_choice = win.getstr
      break if %w[q r n b].include?(promotion_choice.downcase)
    end
    promotion_choice
  end

  private

  def valid_alpha?(alpha_string)
    return false unless alpha_string.length == 2

    first_char = alpha_string[0].downcase
    return false unless ("a".."h").include?(first_char)

    last_char = alpha_string[-1]
    return false unless ("1".."8").include?(last_char)

    true
  end

  def invalid_alpha_message(invalid_alpha)
    win.clear
    reset_position
    win.addstr(
      "#{invalid_alpha} is not a valid square in algebraic chess notation. Please try again."
    )
    win.refresh
    sleep 3
  end

  def illegal_move_message
    win.clear
    reset_position
    win.addstr(
      "Your move from #{from_alpha}: #{from_alpha.length} to #{to_alpha}: #{to_alpha.length} is not legal. You must move a piece of your color to a legal square. Please try again."
    )
    win.refresh
    sleep 3
  end

  attr_accessor :from_alpha, :to_alpha
end

class MoveTranslator
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def alpha_to_move(color, alpha_string_from, alpha_string_to)
    from_coord = alpha_to_coord(alpha_string_from)
    to_coord = alpha_to_coord(alpha_string_to)

    Move.new(color, from_coord, to_coord, board)
  end

  private

  def alpha_to_coord(alpha_string)
    first_char_sym = alpha_string[0].to_sym
    second_char_int = alpha_string[1].to_i

    coord_x = ALPHA_TO_X[first_char_sym]
    coord_y = second_char_int - 1

    Coordinate.new(coord_x, coord_y)
  end
end
