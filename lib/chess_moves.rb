class Move
  attr_reader :color, :from_coord, :to_coord, :board, :piece

  def initialize(color, from_coord, to_coord, board)
    @color = color
    @from_coord = from_coord
    @to_coord = to_coord
    @board = board
    @piece = board.piece_at(from_coord.value_array)
  end

  def legal?
    return false if piece.is_a?(NilPiece)
    return false unless piece.color == color

    return true if piece.legal_regular_moves.any? { |move| equal?(move) }
    return true if legal_castle?
    return true if legal_en_passant?

    false
  end

  def adjacent_coordinate
    adjustment = -1 if piece.white?
    adjustment = 1 if piece.black?

    Coordinate.new(to_coord.x_value, to_coord.y_value + adjustment)
  end

  def pawn_double?
    return false unless double_coordinate.equal?(from_coord)
    return false unless piece.pawn?
    return false if piece.moved?

    true
  end

  def coordinates_array
    [from_coord.value_array, to_coord.value_array]
  end

  def equal?(other)
    return false unless coordinates_array == other.coordinates_array
    return false unless other.color == color

    true
  end

  def kingside?
    to_coord.equal?(kingside_to_coordinate)
  end

  def queenside?
    to_coord.equal?(queenside_to_coordinate)
  end

  def en_passant?
    return false unless piece.pawn?
    return false unless piece.fifth_rank?

    adjacent_piece = board.piece_at(adjacent_coordinate.value_array)
    return false unless adjacent_piece.pawn?
    return false if adjacent_piece.color == color
    return false unless board.last_moved_two == adjacent_piece

    true
  end

  private

  def legal_castle?
    corner_piece = kingside_corner_piece if kingside?
    corner_piece = queenside_corner_piece if queenside?

    return false unless castle?(corner_piece)

    return false if board.in_check?(color)

    pieces_between.each do |between|
      mock_board =
        board.mock_result(
          from_coord.value_array,
          between.coordinate.value_array
        )
      return false if mock_board.in_check?(color)
    end

    true
  end

  def castle?(corner_piece)
    return false unless piece.king?
    return false if piece.moved?
    return false unless valid_castle_coord?

    return false unless corner_piece.is_a?(Rook)
    return false if corner_piece.moved?
    return false unless pieces_between.all? { |piece| piece.is_a?(NilPiece) }

    true
  end

  def valid_castle_coord?
    kingside? || queenside?
  end

  def kingside_to_coordinate
    return Coordinate.new(6, 0) if piece.white?
    return Coordinate.new(6, 7) if piece.black?
  end

  def queenside_to_coordinate
    return Coordinate.new(2, 0) if piece.white?
    return Coordinate.new(2, 7) if piece.black?
  end

  def kingside_corner_piece
    return board.piece_at(Coordinate.new(7, 0).value_array) if piece.white?
    return board.piece_at(Coordinate.new(7, 7).value_array) if piece.black?
  end

  def queenside_corner_piece
    return board.piece_at(Coordinate.new(0, 0).value_array) if piece.white?
    return board.piece_at(Coordinate.new(0, 7).value_array) if piece.black?
  end

  def pieces_between
    between_x = from_coord.x_value
    between_y = from_coord.y_value

    between_array = []

    loop do
      between_x += 1 if kingside?
      between_x -= 1 if queenside?
      break if between_x.zero?
      break if between_x > 6

      next_coordinate = Coordinate.new(between_x, between_y)
      between_array.push(board.piece_at(next_coordinate.value_array))
    end

    between_array
  end

  def legal_en_passant?
    return false unless en_passant?

    mock_board = board.mock_result(from_coord.value_array, to_coord.value_array)
    return false if mock_board.in_check?(color)

    true
  end

  def promotion?
    return false unless piece.pawn?
    return false unless piece.second_last_rank?

    true
  end

  def regular?
    return false if promotion?
    return false if en_passant?
    return false if castle?

    true
  end

  def double_coordinate
    adjustment = -2 if piece.white?
    adjustment = 2 if piece.black?

    Coordinate.new(to_coord.x_value, to_coord.y_value + adjustment)
  end
end
