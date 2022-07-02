require_relative "chess_input"
require_relative "chess_pieces"
require_relative "chess_moves"

include Alphanumeric_Key

class BoardOutput
  attr_reader :message_win, :board_win

  BLACK_SYMBOLS = {
    pawn: "♙",
    rook: "♖",
    knight: "♘",
    bishop: "♗",
    queen: "♕",
    king: "♔"
  }

  WHITE_SYMBOLS = {
    pawn: "♟",
    rook: "♜",
    knight: "♞",
    bishop: "♝",
    queen: "♛",
    king: "♚"
  }

  def initialize(board_win = nil, message_win = nil)
    @board_win = board_win
    @message_win = message_win

    message_win.setpos(2, 2) unless message_win.nil?

    unless board_win.nil?
      board_win.box("|", "-")
      board_win.setpos((board_win.maxy / 2) - 4, (board_win.maxx / 2) - 10)
    end
  end

  def welcome
    message_win.clear
    message_win.setpos(0, 0)
    message_win.addstr(
      "
      ░█████╗░██╗░░██╗███████╗░██████╗░██████╗
      ██╔══██╗██║░░██║██╔════╝██╔════╝██╔════╝
      ██║░░╚═╝███████║█████╗░░╚█████╗░╚█████╗░
      ██║░░██╗██╔══██║██╔══╝░░░╚═══██╗░╚═══██╗
      ╚█████╔╝██║░░██║███████╗██████╔╝██████╔╝
      ░╚════╝░╚═╝░░╚═╝╚══════╝╚═════╝░╚═════╝░"
    )
    message_win.refresh
  end

  def final_message(color)
    message_win.clear
    message_win.setpos(2, 2)
    message_win.addstr('Game over, it\'s a draw.') if color.nil?
    message_win.addstr("Game over, #{color.name} wins.\n") unless color.nil?
    message_win.refresh
    sleep 5
  end

  def display_board(board, color, print = false)
    set_window unless print
    8.times do |count_y|
      y_value = count_y if color.black?
      y_value = 7 - count_y if color.white?

      display("#{y_value + 1} ", print)

      8.times do |count_x|
        x_value = 7 - count_x if color.black?
        x_value = count_x if color.white?

        square = board.squares[x_value][y_value]

        if square.is_a?(NilPiece)
          display("| ", print) unless count_x == 7
          if count_x == 7
            display("| |", print)
            unless print
              board_win.setpos(board_win.cury + 1, board_win.curx - 19)
            end
          end
          next
        end

        piece_type = square.type.to_sym
        symbol = WHITE_SYMBOLS[piece_type] if square.white?
        symbol = BLACK_SYMBOLS[piece_type] if square.black?

        display("|#{symbol}", print) unless count_x == 7
        if count_x == 7
          display("|#{symbol}|", print)
          board_win.setpos(board_win.cury + 1, board_win.curx - 19) unless print
        end
      end
      puts if print

      display("   a b c d e f g h", print) if count_y == 7 && color.white?
      display("   h g f e d c b a", print) if count_y == 7 && color.black?
    end
    board_win.refresh unless print
    puts if print
  end
end

def set_window
  board_win.clear
  board_win.box("|", "-")
  board_win.setpos((board_win.maxy / 2) - 4, (board_win.maxx / 2) - 10)
end

def display(string, print)
  board_win.addstr(string) unless print
  print "#{string}" if print
end

class BoardSetter
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def empty_board_array
    board_array = []
    8.times do |count_x|
      board_array.push([])
      8.times do |count_y|
        piece_coordinate = Coordinate.new(count_x, count_y)
        board_array[count_x].push(NilPiece.new(piece_coordinate))
      end
    end
    board_array
  end

  def create_pieces(colors)
    pieces_array = []
    black = colors[0]
    white = colors[1]
    # puts "starting_colors: #{colors}"
    pieces_array += (create_starting_pieces(black))
    pieces_array += (create_starting_pieces(white))
    pieces_array
  end

  def create_starting_pieces(color)
    first_rank, second_rank = starting_ranks(color)

    pieces_array = []

    8.times do |x_value|
      pawn_coord = Coordinate.new(x_value, second_rank)
      pieces_array.push(Pawn.new(color, pawn_coord, board))
    end

    rook_coord_0 = Coordinate.new(0, first_rank)
    rook_coord_7 = Coordinate.new(7, first_rank)
    pieces_array.push(Rook.new(color, rook_coord_0, board))
    pieces_array.push(Rook.new(color, rook_coord_7, board))

    knight_coord_1 = Coordinate.new(1, first_rank)
    knight_coord_6 = Coordinate.new(6, first_rank)
    pieces_array.push(Knight.new(color, knight_coord_1, board))
    pieces_array.push(Knight.new(color, knight_coord_6, board))

    bishop_coord_2 = Coordinate.new(2, first_rank)
    bishop_coord_5 = Coordinate.new(5, first_rank)
    pieces_array.push(Bishop.new(color, bishop_coord_2, board))
    pieces_array.push(Bishop.new(color, bishop_coord_5, board))

    queen_coord = Coordinate.new(3, first_rank)
    pieces_array.push(Queen.new(color, queen_coord, board))

    king_coord = Coordinate.new(4, first_rank)
    pieces_array.push(King.new(color, king_coord, board))

    pieces_array
  end

  def starting_ranks(color)
    if color.white?
      first_rank = 0
      second_rank = 1
    end

    if color.black?
      first_rank = 7
      second_rank = 6
    end

    return first_rank, second_rank
  end

  def populate_squares
    squares_array = empty_board_array
    board.pieces.each do |piece|
      x_value = piece.coordinate.x_value
      y_value = piece.coordinate.y_value
      squares_array[x_value][y_value] = piece
    end
    squares_array
  end
end

class PieceMover
  OPTION_TO_PIECE = { q: "Queen", r: "Rook", n: "Knight", b: "Bishop" }

  def initialize
    @captured_piece = NilPiece.new
    @moving_piece = NilPiece.new
    @previous_last_moved = NilPiece.new
  end

  def execute_regular(move, board)
    from_coord = move.from_coord
    to_coord = move.to_coord

    self.moving_piece = board.remove_piece(from_coord)

    captured_coord = to_coord
    captured_coord = move.adjacent_piece.coordinate if move.en_passant?

    self.captured_piece = board.remove_piece(captured_coord)
    board.add_piece(moving_piece, to_coord)
    set_last_moved(move, board)
  end

  def reverse_regular(move, board)
    board.remove_piece(move.to_coord)
    board.add_piece(captured_piece, move.to_coord, false)
    board.add_piece(moving_piece, move.from_coord, false)

    reset_last_moved(move, board)
    moving_piece.revert_move
  end

  def execute_castle(move, board)
    if move.kingside?
      rook_from_x = 7
      rook_to_x = 5
    end

    if move.queenside?
      rook_from_x = 0
      rook_to_x = 3
    end

    moving_king = board.remove_piece(move.from_coord)

    rook_y = move.from_coord.y_value
    rook_old_coord = Coordinate.new(rook_from_x, rook_y)
    moving_rook = board.remove_piece(rook_old_coord)

    rook_new_coord = Coordinate.new(rook_to_x, rook_y)
    board.add_piece(moving_rook, rook_new_coord, false)
    board.add_piece(moving_king, move.to_coord, false)
  end

  def reverse_castle(move, board)
    king = board.remove_piece(move.to_coord)
    rook = board.remove_piece(rook_new_coord)
    board.add_piece(king, move.from_coord, false)
    board.add_piece(rook, rook_old_coord, false)
    reset_last_moved(move, board)
    king.revert_move
    rook.revert_move
  end

  def execute_promotion(move, board, mock = false)
    option = board.input.promotion_option unless mock
    new_piece = option_to_piece(option, move) unless mock
    new_piece = Queen.new(move.color, to_coord, board) if mock
    self.captured_piece = board.remove_piece(move.from_coord)
    self.moving_piece = board.add_piece(new_piece, move.to_coord)
  end

  def set_last_moved(move, board)
    self.previous_last_moved = board.last_moved_two
    board.last_moved_two = NilPiece.new unless move.pawn_double?
    board.last_moved_two = move.piece if move.pawn_double?
  end

  def reset_last_moved(move, board)
    board.last_moved_two = previous_last_moved
  end

  def option_to_piece(option_char, move)
    option_sym = option_char.to_sym
    Object.const_get(OPTION_TO_PIECE[option_sym]).new(
      move.color,
      move.to_coord,
      self
    )
  end

  private

  attr_accessor :captured_piece, :moving_piece, :previous_last_moved
end

class ChessBoard
  attr_reader :input, :mover, :colors, :setter
  attr_accessor :last_moved_two, :pieces, :squares, :evaluator

  def initialize(input, colors)
    @last_moved_two = nil
    @input = input
    @colors = colors
    @mover = PieceMover.new
    @evaluator = BoardEvaluator.new(self)
    @setter = BoardSetter.new(self)
    @pieces = setter.create_pieces(colors)
    @squares = setter.populate_squares
  end

  # def mock_resolve(move)
  #   board_copy = Marshal.load(Marshal.dump(self))
  #   board_copy.input.win = input.win
  #   # puts "mock resolve: #{move.piece.info_string}, #{move.from_coord.value_array}, #{move.to_coord.value_array}"
  #   mover.execute_regular(move, board_copy) if move.regular? || move.en_passant?
  #   mover.execute_castle(move, board_copy) if move.castle?
  #   mover.execute_mock_promotion(move, board_copy) if move.promotion?
  #   board_copy
  # end

  def resolve(move, mock = false)
    # print_pieces
    # puts "resolve: #{move.piece.info_string}, #{move.from_coord.value_array}, #{move.to_coord.value_array}"
    mover.execute_regular(move, self) if move.regular? || move.en_passant?
    mover.execute_castle(move, self) if move.castle?
    mover.execute_promotion(move, self, mock) if move.promotion?
    self
  end

  def reverse_resolve(move)
    if move.regular? || move.en_passant? || move.promotion?
      mover.reverse_regular(move, self)
    end
    mover.reverse_castle(move, self) if move.castle?
  end

  def in_check?(color)
    # print_squares
    evaluator.in_check?(color)
  end

  def stalemate?(colors)
    evaluator.stalemate?(colors)
  end

  def checkmate?(color)
    evaluator.checkmate?(color)
  end

  def insufficient_material?
    evaluator.insufficient_material?
  end

  def print_pieces
    pieces.each { |p| puts p.info_string }
  end

  def print_squares
    8.times do |square|
      8.times { |column| puts squares[column][square].info_string }
    end
  end

  def piece_at(coordinate)
    squares[coordinate.x_value][coordinate.y_value]
  end

  def add_piece(piece, coordinate, set_has_moved = true)
    # puts "adding #{piece.info_string} to #{coordinate.value_array}"
    unless piece_at(coordinate).is_a?(NilPiece)
      raise "Coordinate at #{coordinate.value_array} is not empty. Cannot add a piece."
    end

    piece.previous_coordinate = piece.coordinate
    piece.coordinate = coordinate

    self.pieces.push(piece) unless piece.is_a?(NilPiece)
    self.squares[coordinate.x_value][coordinate.y_value] = piece

    piece.set_has_moved if set_has_moved
    piece
  end

  def remove_piece(coordinate)
    removed_piece = piece_at(coordinate)
    # puts "removing #{removed_piece.info_string} from #{coordinate.value_array}"
    x_value = coordinate.x_value
    y_value = coordinate.y_value
    self.squares[x_value][y_value] = NilPiece.new(
      Coordinate.new(x_value, y_value)
    )
    pieces.delete(removed_piece)
    removed_piece
  end

  def king_of_color(color)
    king_array = pieces.select { |piece| piece.king? }
    # king_array.each { |king| puts "#{king.color}, #{color}" }
    king_array = king_array.select { |king| king.color == color }
    # puts "#{king_array.length}"
    king_array[0]
  end

  def reachable?(test_piece)
    pieces.any? do |piece|
      piece.reachable_coordinates.any? do |coord|
        coord == test_piece.coordinate
      end
    end
  end
end

class BoardEvaluator
  def initialize(board)
    @board = board
  end

  def in_check?(color)
    king = board.king_of_color(color)
    # puts "in_check color: #{color}"
    # board.print_pieces
    board.reachable?(king)
  end

  def stalemate?(colors)
    black = colors[0]
    white = colors[1]
    return false if board.in_check?(black)
    return false if board.in_check?(white)

    board.pieces.all? { |piece| piece.legal_regular_moves.empty? }
  end

  def checkmate?(color)
    return false unless board.in_check?(color)
    king = board.king_of_color(color)

    king.legal_regular_moves.empty?
  end

  def insufficient_material?
    return true if board.pieces.length == 2

    if board.pieces.length == 3
      return true if number_bishops == 1
      return true if number_knights == 1
    end

    return false unless board.pieces.length == 4
    return false unless number_bishops == 2
    return true if bishops[0].color != bishops[1].color

    false
  end

  private

  def number_bishops
    bishops.length
  end

  def number_knights
    board.pieces.count { |piece| piece.knight? }
  end

  def bishops
    board.pieces.filter { |piece| piece.bishop? }
  end

  attr_reader :board
end
