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
              :input_window

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

    @board = ChessBoard.new(input, colors)
    @current_turn = white
  end

  def play
    output.welcome
    loop do
      output.display_board(board, current_turn)
      move = input.move(current_turn, board)
      board.resolve(move)
      break unless continue?(colors)
      self.current_turn = current_turn.opposite
    end
    output.display_board(board, current_turn)
    winner = determine_winner
    output.final_message(winner)
  end

  def continue?(colors)
    return false if board.checkmate?(current_turn.opposite)
    return false if board.insufficient_material?
    return false if board.stalemate?(colors)

    true
  end

  def determine_winner
    return current_turn if board.checkmate?(current_turn.opposite)

    nil
  end

  private

  attr_writer :winner, :current_turn
end

class Screen
  def initialize
    init_screen
    nocbreak
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

# class Window
#   def dump
#   end
# end

game = ChessManager.new
game.play
