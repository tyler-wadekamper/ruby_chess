class Move
  attr_reader :color, :from_coord, :to_coord, :board, :piece, :manager

  def initialize(color, from_coord, to_coord, manager)
    @color = color
    @from_coord = from_coord
    @to_coord = to_coord
    @manager = manager
    @piece = nil
  end

  def piece(board)
    return @piece unless @piece.nil?
    @piece = board.piece_at(from_coord)
    @piece
  end

  def legal?(board)
    return false if piece(board).is_a?(NilPiece)
    return false unless piece(board).color == color

    return true if piece(board).legal_regular_moves.any? { |move| move == self }
    return true if legal_castle?(board)
    return true if legal_en_passant?(board)

    false
  end

  def adjacent_coordinate(board)
    adjustment = -1 if piece(board).white?
    adjustment = 1 if piece(board).black?

    Coordinate.new(to_coord.x_value, to_coord.y_value + adjustment)
  end

  def pawn_double?(board)
    return false unless double_coordinate(board) == from_coord
    return false unless piece(board).pawn?

    true
  end

  def coordinates_array
    [from_coord.value_array, to_coord.value_array]
  end

  def ==(other)
    return false unless from_coord == other.from_coord
    return false unless to_coord == other.to_coord
    return false unless other.color == color

    true
  end

  def kingside?(board)
    to_coord == kingside_to_coordinate(board)
  end

  def queenside?(board)
    to_coord == queenside_to_coordinate(board)
  end

  def en_passant?(board)
    return false unless piece(board).pawn?
    return false unless piece(board).fifth_rank?

    adjacent_piece = board.piece_at(adjacent_coordinate(board))
    return false unless adjacent_piece.pawn?
    return false if adjacent_piece.color == color
    return false unless board.last_moved_two == adjacent_piece

    puts "returning true"
    true
  end

  def legal_castle?(board)
    return false unless castle?(board)
    return false if board.in_check?(color)

    pieces_between(board).each do |between|
      move = Move.new(color, from_coord, between.coordinate, manager)

      mock_list = manager.move_list_copy.push(move)
      mock_board = ChessBoard.new(manager, mock_list)

      return false if mock_board.in_check?(color)
    end

    true
  end

  def castle?(board)
    corner_piece = kingside_corner_piece(board) if kingside?(board)
    corner_piece = queenside_corner_piece(board) if queenside?(board)

    return false unless piece(board).king?
    return false if piece(board).moved?
    return false unless valid_castle_coord?(board)

    return false unless corner_piece.is_a?(Rook)
    return false if corner_piece.moved?
    unless pieces_between(board).all? { |piece| piece.is_a?(NilPiece) }
      return false
    end

    true
  end

  def valid_castle_coord?(board)
    kingside?(board) || queenside?(board)
  end

  def kingside_to_coordinate(board)
    return Coordinate.new(6, 0) if piece(board).white?
    return Coordinate.new(6, 7) if piece(board).black?
  end

  def queenside_to_coordinate(board)
    return Coordinate.new(2, 0) if piece(board).white?
    return Coordinate.new(2, 7) if piece(board).black?
  end

  def kingside_corner_piece(board)
    return board.piece_at(Coordinate.new(7, 0)) if piece(board).white?
    return board.piece_at(Coordinate.new(7, 7)) if piece(board).black?
  end

  def queenside_corner_piece(board)
    return board.piece_at(Coordinate.new(0, 0)) if piece(board).white?
    return board.piece_at(Coordinate.new(0, 7)) if piece(board).black?
  end

  def pieces_between(board)
    between_x = from_coord.x_value
    between_y = from_coord.y_value

    between_array = []

    loop do
      between_x += 1 if kingside?(board)
      between_x -= 1 if queenside?(board)
      break if between_x.zero?
      break if between_x > 6

      next_coordinate = Coordinate.new(between_x, between_y)
      between_array.push(board.piece_at(next_coordinate))
    end

    between_array
  end

  def legal_en_passant?(board)
    return false unless en_passant?(board)

    mock_board = manager.mock_board(self)

    return false if mock_board.in_check?(color)

    true
  end

  def promotion?(board)
    return false unless piece(board).pawn?
    return false unless piece(board).second_last_rank?

    true
  end

  def double_coordinate(board)
    adjustment = -2 if piece(board).white?
    adjustment = 2 if piece(board).black?

    if to_coord.nil? || from_coord.nil?
      puts "from_coord nil? #{from_coord.nil?}, to_coord nil? #{to_coord.nil?}"
    end
    if to_coord.x_value.nil? || to_coord.y_value.nil?
      puts "to_coord x nil? #{to_coord.x_value.nil?}, to_coord y nil? #{to_coord._value.ynil?}"
    end

    Coordinate.new(to_coord.x_value, to_coord.y_value + adjustment)
  end
end
