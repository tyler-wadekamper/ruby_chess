require_relative "chess_input"
require_relative "chess_pieces"
require_relative "chess_moves"

include Alphanumeric_Key

class BoardOutput
  OWN_COLOR_SYMBOLS = {
    pawn: "♙",
    rook: "♖",
    knight: "♘",
    bishop: "♗",
    queen: "♕",
    king: "♔"
  }

  OPPOSITE_COLOR_SYMBOLS = {
    pawn: "♟",
    rook: "♜",
    knight: "♞",
    bishop: "♝",
    queen: "♛",
    king: "♚"
  }

  attr_reader :message_win, :board_win, :opposite, :own

  def initialize(board_win = nil, message_win = nil)
    @board_win = board_win
    @message_win = message_win

    @opposite = OPPOSITE_COLOR_SYMBOLS
    @own = OWN_COLOR_SYMBOLS

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
      y_value = y_value(count_y, color)

      display("#{y_value + 1} ", print)

      8.times do |count_x|
        x_value = x_value(count_x, color)

        square_color = square_color(x_value, y_value) unless print

        piece = board.squares[x_value][y_value]

        set_color(square_color)

        if display_piece(
             piece,
             print,
             board_win,
             square_color,
             count_x,
             count_y
           )
          next
        end
      end
      set_default_color unless print
      puts if print

      display_coordinate_labels(color, count_y, print)
    end
    board_win.refresh unless print
    puts if print
  end

  def display_coordinate_labels(color, count_y, print)
    display("   a  b  c  d  e  f  g  h ", print) if count_y == 7 && color.white?
    display("   h  g  f  e  d  c  b  a ", print) if count_y == 7 && color.black?
  end

  def display_piece(piece, print, board_win, square_color, count_x, count_y)
    if piece.is_a?(NilPiece)
      display("\u200a\u200a\u200a", print, count_x)
      if count_x == 7
        board_win.setpos(board_win.cury + 1, board_win.curx - 26) unless print
      end
      return true
    end

    piece_type = piece.type.to_sym

    symbol = get_symbol(piece_type, piece, square_color, print)

    display("\u200a#{symbol}\u200a", print, count_x)
    if count_x == 7
      board_win.setpos(board_win.cury + 1, board_win.curx - 26) unless print
    end
    false
  end

  def get_symbol(piece_type, piece, square_color, print)
    unless print
      return opposite[piece_type] if piece.color.name != square_color
      return own[piece_type] if piece.color.name == square_color
    end

    if print
      return opposite[piece_type] if piece.color.white?
      return own[piece_type] if piece.color.black?
    end
  end

  def y_value(count_y, color)
    return count_y if color.black?
    return 7 - count_y if color.white?
  end

  def x_value(count_x, color)
    return 7 - count_x if color.black?
    return count_x if color.white?
  end

  def square_color(x_value, y_value)
    return "black" if x_value.odd? == y_value.odd?
    return "white" if x_value.odd? != y_value.odd?
  end

  def set_color(square_color)
    set_white_on_black if square_color == "black"
    set_black_on_white if square_color == "white"
  end

  def set_white_on_black
    board_win.attron(color_pair(1))
  end

  def set_black_on_white
    board_win.attron(color_pair(2))
  end

  def set_default_color
    board_win.attroff(color_pair(1))
    board_win.attroff(color_pair(2))
  end

  def set_window
    board_win.clear
    board_win.box("|", "-")
    board_win.setpos((board_win.maxy / 2) - 4, (board_win.maxx / 2) - 14)
  end

  def display(string, print, count_x = 0)
    unless print
      board_win.addstr(string)
      return
    end

    if string == "   a  b  c  d  e  f  g  h "
      print "  a b c d e f g h "
      return
    end

    if string == "   h  g  f  e  d  c  b  a "
      print "  h g f e d c b a "
      return
    end

    string[0] = "|" if string[0] == "\u200a"
    string[1] = " " if string[1] == "\u200a"
    string[2] = "|" if string[2] == "\u200a"
    string.chop! unless count_x == 7
    print "#{string}"
  end
end

class BoardSetter
  attr_reader :board, :manager

  def initialize(board, manager)
    @board = board
    @manager = manager
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

    [first_rank, second_rank]
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

  def execute_regular(move, board)
    from_coord = move.from_coord
    to_coord = move.to_coord

    moving_piece = board.remove_piece(from_coord)

    captured_coord = to_coord
    captured_coord = move.adjacent_coordinate(board) if move.en_passant?(board)

    board.remove_piece(captured_coord)
    board.add_piece(moving_piece, to_coord)
    set_last_moved(move, board, moving_piece)
  end

  def execute_castle(move, board)
    if move.kingside?(board)
      rook_from_x = 7
      rook_to_x = 5
    end

    if move.queenside?(board)
      rook_from_x = 0
      rook_to_x = 3
    end

    moving_king = board.remove_piece(move.from_coord)

    rook_y = move.from_coord.y_value
    rook_old_coord = Coordinate.new(rook_from_x, rook_y)
    moving_rook = board.remove_piece(rook_old_coord)

    rook_new_coord = Coordinate.new(rook_to_x, rook_y)
    board.add_piece(moving_rook, rook_new_coord)
    board.add_piece(moving_king, move.to_coord)
  end

  def execute_promotion(move, board, mock)
    option = board.input.promotion_option(mock)
    new_piece = option_to_piece(option, move, board)
    board.remove_piece(move.to_coord)
    board.remove_piece(move.from_coord)
    board.add_piece(new_piece, move.to_coord)
  end

  def set_last_moved(move, board, moving_piece)
    board.last_moved_two = NilPiece.new unless move.pawn_double?(board)
    board.last_moved_two = moving_piece if move.pawn_double?(board)
  end

  def option_to_piece(option_char, move, board)
    option_sym = option_char.to_sym
    Object.const_get(OPTION_TO_PIECE[option_sym]).new(
      move.color,
      move.to_coord,
      board
    )
  end
end

class ChessBoard
  attr_reader :input, :mover, :colors, :setter, :move_list, :manager, :mock
  attr_accessor :last_moved_two, :pieces, :squares, :evaluator

  def initialize(manager, move_list = [], mock: false)
    @last_moved_two = nil
    @manager = manager
    @input = manager.input
    @colors = manager.colors
    @mover = PieceMover.new
    @evaluator = BoardEvaluator.new(self)
    @setter = BoardSetter.new(self, manager)
    @pieces = setter.create_pieces(colors)
    @squares = setter.populate_squares
    @move_list = move_list
    @mock = mock
    execute_move_list
  end

  def execute_move_list
    move_list.each { |move| resolve(move, mock) }
  end

  def resolve(move, mock)
    castle = move.castle?(self)
    promotion = move.promotion?(self)

    if promotion
      mover.execute_promotion(move, self, mock)
    elsif castle
      mover.execute_castle(move, self)
    else
      mover.execute_regular(move, self)
    end

    self
  end

  def in_check?(color)
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

  def add_piece(piece, coordinate)
    unless piece_at(coordinate).is_a?(NilPiece)
      raise "Coordinate at #{coordinate.value_array} is not empty. Cannot add a piece."
    end

    piece.coordinate = coordinate

    pieces.push(piece) unless piece.is_a?(NilPiece)
    squares[coordinate.x_value][coordinate.y_value] = piece

    piece.set_has_moved
    piece
  end

  def remove_piece(coordinate)
    removed_piece = piece_at(coordinate)
    x_value = coordinate.x_value
    y_value = coordinate.y_value
    squares[x_value][y_value] = NilPiece.new(Coordinate.new(x_value, y_value))
    pieces.delete(removed_piece)
    removed_piece
  end

  def king_of_color(color)
    king_array = pieces.select(&:king?)
    king_array = king_array.select { |king| king.color == color }
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
    board.reachable?(king)
  end

  def stalemate?(color)
    return false if board.in_check?(color)

    cant_move?(color)
  end

  def checkmate?(color)
    return false unless board.in_check?(color)

    cant_move?(color)
  end

  def cant_move?(color)
    color_pieces = board.pieces.filter { |piece| piece.color == color }

    color_pieces.all? { |piece| piece.legal_regular_moves.empty? }
  end

  def insufficient_material?
    return true if board.pieces.length == 2

    if board.pieces.length == 3
      return true if number_bishops == 1
      return true if number_knights == 1
    end

    return false unless board.pieces.length == 4
    return false unless number_bishops == 2
    if bishops[0].coordinate.light_square? ==
         bishops[1].coordinate.light_square?
      return true
    end

    false
  end

  private

  def number_bishops
    bishops.length
  end

  def number_knights
    board.pieces.count(&:knight?)
  end

  def bishops
    board.pieces.filter(&:bishop?)
  end

  attr_reader :board
end
