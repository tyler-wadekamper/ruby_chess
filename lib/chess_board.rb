require "./lib/chess_input.rb"
require "./lib/chess_pieces.rb"
require "./lib/chess_moves.rb"
include Alphanumeric_Key

class BoardOutput
  PIECE_SYMBOLS = {
    pawn: "P",
    rook: "R",
    knight: "N",
    bishop: "B",
    queen: "Q",
    king: "K"
  }

  def initialize
  end

  def welcome
    puts "Welcome to chess. White, make your first move."
  end

  def final_message(color)
    puts 'Game over, it\'s a draw.' if color.nil?
    puts "Game over, #{color.name} wins." unless color.nil?
  end

  def display_board(board, color)
    puts "________________"
    8.times do |y_value|
      8.times do |x_value|
        square = board.squares[x_value][y_value]
        if square.is_a?(NilPiece)
          print "| " unless x_value == 7
          print "| |" if x_value == 7
          next
        end
        piece_type = square.type.to_sym
        print "|#{PIECE_SYMBOLS[piece_type]}" unless x_value == 7
        print "|#{PIECE_SYMBOLS[piece_type]}|" if x_value == 7
      end
      puts
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

  def stalemate?(colors)
    black = colors[0]
    white = colors[1]
    return false if board.in_check?(black)
    return false if board.in_check?(white)

    pieces.all? { |piece| piece.legal_regular_moves.empty? }
  end

  def checkmate?(color)
    return false unless board.in_check?(color)
    king = board.king_of_color(color)

    king.legal_regular_moves.empty?
  end

  def insufficient_material?
    return true if board.pieces.length == 2

    if pieces.length == 3
      return true if number_bishops == 1
      return true if number_knights == 1
    end

    return false unless pieces.length == 4
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

  def execute_regular(move, board)
    from_value = move.from_coord.value_array
    to_value = move.from_coord.value_array

    moving_piece = board.remove_piece(from_value)

    captured_value = to_value
    captured_value =
      move.adjacent_piece.coordinate.value_array if move.en_passant?

    captured_piece = board.remove_piece(captured_value)
    board.add_piece(moving_piece, to_value)
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

    moving_king = board.remove_piece(move.from_coord.value_array)

    rook_y = move.from_coord.y_value
    rook_old_coord = Coordinate.new(rook_from_x, rook_y)
    moving_rook = board.remove_piece(rook_old_coord.value_array)

    rook_new_coord = Coordinate.new(rook_to_x, rook_y)
    board.add_piece(moving_rook, rook_new_coord.value_array)
    board.add_piece(moving_king, move.to_coord.value_array)
  end

  def execute_promotion(move, board)
    option = board.input.promotion_option
    new_piece = option_to_piece(option, move)
    board.remove_piece(move.from_coord.value_array)
    board.add_piece(new_piece, move.to_coord.value_array)
  end

  def execute_mock_promotion(move, board)
    new_piece = option_to_piece("q", move)
    board.remove_piece(move.from_coord.value_array)
    board.add_piece(new_piece, move.to_coord.value_array)
  end

  def set_last_moved(move, board)
    board.last_moved_two = NilPiece.new unless move.pawn_double?
    board.last_moved_two = move.piece if move.pawn_double?
  end

  def option_to_piece(option_char, move)
    option_sym = option_char.to_sym
    Object.const_get(OPTION_TO_PIECE[option_sym]).new(
      move.color,
      move.to_coord,
      self
    )
  end
end

class Board
  attr_reader :input, :mover, :evaluator, :squares, :pieces, :colors, :setter
  attr_accessor :last_moved_two

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

  def mock_resolve(move)
    board_copy = self
    mover.execute_castle(move, board_copy) if move.castle?
    mover.execute_regular(move, board_copy) if move.regular? || move.en_passant?
    mover.execute
  end

  def resolve(move)
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

  def piece_at(coord_value_array)
    x_value = coord_value_array[0]
    y_value = coord_value_array[1]
    squares[x_value][y_value]
  end

  def add_piece(piece, coordinate_value_array)
    unless piece_at(coordinate.value_array.is_a?(NilPiece))
      raise "Coordinate at #{coordinate.value_array} is not empty. Cannot add a piece."
    end

    x_value = coordinate_value_array.x_value
    y_value = coordinate_value_array.y_value

    piece.coordinate = Coordinate.new(x_value, y_value)

    pieces.push(piece)
    squares[x_value][y_value] = piece

    piece.has_moved = true
    piece
  end

  def remove_piece(coord_value_array)
    removed_piece = piece_at(coord_value_array)
    x_value = coord_value_array[0]
    y_value = coord_value_array[1]
    squares[x_value][y_value] = NilPiece.new(Coordinate.new(x_value, y_value))
    removed_piece
  end

  def king_of_color(color)
    king_array = pieces.select { |piece| piece.king? }
    king_array = king_array.select { |king| king.color == color }
    king_array[0]
  end

  def reachable?(test_piece)
    pieces.any? do |piece|
      piece.reachable_coordinates.any? do |coord|
        coord.equal?(test_piece.coordinate)
      end
    end
  end

  private

  attr_writer :pieces, :squares
end

board = Board.new(nil, [BlackColor.new, WhiteColor.new])
board.print_pieces
puts "#################"
board.print_squares

output = BoardOutput.new
output.display_board(board, nil)
