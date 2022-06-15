module Alphanumeric_Key
  ALPHA_TO_X = { a: 0, b: 1, c: 2, d: 3, e: 4, f: 5, g: 6, h: 7 }.freeze
end

include Alphanumeric_Key
require "./lib/chess_pieces.rb"
require "./lib/chess_moves.rb"

class ChessInput
  def initialize
    @from_alpha = from_alpha
    @to_alpha = to_alpha
  end

  def move(color, board)
    move_object = nil
    loop do
      move_object = get_move_object(color, board)
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
      puts "#{color.name}, input the square you will move #{to_from_string} in algebraic notation (ex: e2):"
      square_choice = gets.chomp
      break if valid_alpha?(square_choice)
      invalid_alpha_message(square_choice)
    end
    square_choice.downcase
  end

  def promotion_option
    loop do
      puts "Please input the letter of the piece you would like to promote to (Q, R, N, or B):"
      promotion_choice = gets.chomp
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
    return false unless ("0".."7").include?(last_char)

    true
  end

  def invalid_alpha_message(invalid_alpha)
    puts "#{invalid_alpha} is not a valid square in algebraic chess notation. Please try again."
  end

  def illegal_move_message
    puts "Your move from #{from_alpha} to #{to_alpha} is not legal. You must move a piece of your color to a legal square. Please try again."
  end

  attr_accessor :from_alpha, :to_alpha
end

class MoveTranslator
  attr_reader :board

  # include Alphanumeric_Key

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
