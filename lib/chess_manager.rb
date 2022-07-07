require_relative "chess_input"
require_relative "chess_pieces"
require_relative "chess_moves"
require_relative "chess_board"

require "curses"
include Curses

class ChessManager
  attr_reader :winner,
              :output,
              :input,
              :current_turn,
              :black,
              :white,
              :colors,
              :board,
              :screen,
              :output_window,
              :input_window,
              :move_list

  def initialize
    @winner = nil
    @screen = Screen.new
    @output = BoardOutput.new(screen.board_window, screen.message_window)
    @input = ChessInput.new(screen.input_window)

    @black = BlackColor.new
    @white = WhiteColor.new
    @colors = [black, white]

    black.opposite = white
    white.opposite = black

    @board = ChessBoard.new(self)
    @current_turn = white

    @move_list = []
  end

  def play
    output.welcome
    loop do
      output.display_board(board, current_turn)

      move = nil
      loop do
        move = input.get_move_object(current_turn, board, self)
        break if move.legal?(board)
        input.illegal_move_message
      end

      move_list.push(move)
      self.board = ChessBoard.new(self, move_list)

      break unless continue?(colors)
      self.current_turn = current_turn.opposite
    end
    output.display_board(board, current_turn)
    winner = determine_winner
    output.final_message(winner)
  end

  def test_play(move_arrays)
    moves = []
    move_arrays.each do |array|
      moves.push(Move.new(array[0], array[1], array[2], self))
    end

    move = nil
    move_arrays.each_with_index do |array, count|
      output.display_board(board, current_turn, true)

      move = moves[count]
      loop do
        legal = move.legal?(board)
        break if legal
        puts "illegal move: #{legal}, #{move.coordinates_array}"
        return 0
        # input.illegal_move_message
      end

      move_list.push(move)
      self.board = ChessBoard.new(self, move_list)

      break unless continue?(colors)
      self.current_turn = current_turn.opposite
    end
    output.display_board(board, current_turn, true)
  end

  def continue?(colors)
    return false if board.checkmate?(current_turn.opposite)
    return false if board.insufficient_material?
    return false if board.stalemate?(current_turn.opposite)

    true
  end

  def determine_winner
    return current_turn if board.checkmate?(current_turn.opposite)

    nil
  end

  def mock_board(move_to_add)
    mock_list = move_list_copy
    mock_list.push(move_to_add)

    ChessBoard.new(self, mock_list)
  end

  def move_list_copy
    list_array = []
    move_list.each do |move|
      mock_move = move.dup
      list_array.push(mock_move)
    end
    list_array
  end

  private

  attr_writer :winner, :current_turn, :board, :move_list
end

class Screen
  def initialize
    init_screen
    nocbreak
    start_color
    assume_default_colors(-1, -1)
    init_pair(1, 7, 0)
    init_pair(2, 0, 7)
  end

  def board_window
    Window.new(lines / 1.5, cols / 2, 8, cols / 4)
  end

  def message_window
    Window.new(10, cols / 2, 0, cols / 4)
  end

  def input_window
    Window.new(3, cols / 1.2, lines - 2, cols / 7)
  end
end

game = ChessManager.new
# move_arrays = [
#   [game.white, Coordinate.new(3, 1), Coordinate.new(3, 3)],
#   [game.black, Coordinate.new(3, 6), Coordinate.new(3, 4)],
#   [game.white, Coordinate.new(2, 0), Coordinate.new(5, 3)],
#   [game.black, Coordinate.new(2, 7), Coordinate.new(3, 6)],
#   [game.white, Coordinate.new(1, 0), Coordinate.new(2, 2)],
#   [game.black, Coordinate.new(1, 7), Coordinate.new(0, 5)],
#   [game.white, Coordinate.new(3, 0), Coordinate.new(3, 2)],
#   [game.black, Coordinate.new(3, 7), Coordinate.new(1, 7)],
#   [game.white, Coordinate.new(4, 0), Coordinate.new(2, 0)],
#   [game.black, Coordinate.new(1, 6), Coordinate.new(1, 4)],
#   [game.white, Coordinate.new(2, 2), Coordinate.new(4, 3)],
#   [game.black, Coordinate.new(1, 4), Coordinate.new(1, 3)],
#   [game.white, Coordinate.new(0, 1), Coordinate.new(0, 3)],
#   [game.black, Coordinate.new(1, 3), Coordinate.new(0, 2)],
#   [game.white, Coordinate.new(5, 3), Coordinate.new(6, 4)]
# ]
# game.test_play(move_arrays)
# game2 = ChessManager.new
# move_arrays = [
#   [game2.white, Coordinate.new(3, 1), Coordinate.new(3, 3)],
#   [game2.black, Coordinate.new(4, 6), Coordinate.new(4, 4)],
#   [game2.white, Coordinate.new(3, 3), Coordinate.new(3, 4)],
#   [game2.black, Coordinate.new(4, 4), Coordinate.new(4, 3)],
#   [game2.white, Coordinate.new(3, 4), Coordinate.new(3, 5)],
#   [game2.black, Coordinate.new(4, 3), Coordinate.new(4, 2)],
#   [game2.white, Coordinate.new(3, 5), Coordinate.new(2, 6)],
#   [game2.black, Coordinate.new(4, 2), Coordinate.new(5, 1)],
#   [game2.white, Coordinate.new(4, 0), Coordinate.new(5, 1)],
#   [game2.black, Coordinate.new(0, 6), Coordinate.new(0, 5)],
#   [game2.white, Coordinate.new(2, 6), Coordinate.new(3, 7)]
# ]
# game2.test_play(move_arrays)
game.play
