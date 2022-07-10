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

  attr_accessor :move_list

  def initialize(test: false)
    @winner = nil
    unless test
      @screen = Screen.new
      @output = BoardOutput.new(screen.board_window, screen.message_window)
      @input = ChessInput.new(screen.input_window)
    end

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
        move = input.get_move_object(current_turn, board)
        break if move.legal?(board)

        input.illegal_move_message
      end

      move_list.push(move)
      self.board = ChessBoard.new(self, move_list)
      break unless continue?

      self.current_turn = current_turn.opposite
    end
    output.display_board(board, current_turn)
    winner = determine_winner
    output.final_message(winner)
  end

  def continue?
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

    ChessBoard.new(self, mock_list, mock: true)
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

  attr_writer :winner, :current_turn, :board
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
