class WhiteColor
  attr_reader :color, :name

  def initialize
    @name = 'white'
  end
  
  def black?() false end
  def white?() true end
end

class BlackColor
  attr_reader :color, :name

  def initialize
    @name = 'black'
  end
  
  def black?() true end
  def white?() false end
end

class Coordinate
  attr_reader :x_value, :y_value

  ALPHA_TO_X = { a: 0, b: 1, c: 2, d: 3, e: 4, f: 5, g: 6, h: 7 }.freeze

  def initialize(x_value, y_value)
    @x_value = x_value
    @y_value = y_value
  end

  def equal?(coordinate)
    return false unless x_value == coordinate.x_value
    return false unless y_value == coordinate.y_value

    true
  end

  def on_board?
    return false if x_value > 7
    return false if x_value.negative?
    return false if y_value > 7
    return false if y_value.negative?

    true
  end

  def value_array
    [x_value, y_value]
  end

  def to_alpha_string
    return nil unless on_board?

    first_char = ALPHA_TO_X.key(x_value)
    second_char = y_value + 1

    "#{first_char}#{second_char}"
  end
end

class ChessPiece
  attr_reader :color, :offsets, :coordinate,
              :direction_length, :board, :type

  LEFT = Coordinate.new(-1, 0)
  TOP_LEFT = Coordinate.new(-1, 1)
  TOP = Coordinate.new(0, 1)
  TOP_RIGHT = Coordinate.new(1, 1)
  RIGHT = Coordinate.new(0, 1)
  BOT_RIGHT = Coordinate.new(1, -1)
  BOTTOM = Coordinate.new(0, -1)
  BOT_LEFT = Coordinate.new(-1, -1)

  KNIGHT_OFFSETS = [Coordinate.new(-1, -2), Coordinate.new(-2, -1),
                    Coordinate.new(-2, 1), Coordinate.new(-1, 2),
                    Coordinate.new(2, 1), Coordinate.new(1, 2),
                    Coordinate.new(2, -1), Coordinate.new(1, -2)]

  def initialize(color, coordinate, board)
    @board = board
    @color = color
    @coordinate = coordinate
    @offsets = nil
    @type = nil
  end

  def black_offsets
    offsets.map! { |offset| Coordinate.new(offset.x_value, offset.y_value * -1) }
  end

  def reachable_coordinates
    reachable = []
    directions.each do |direction|
      direction.coordinates.each do |coord|
        break if piece_at(coord).same_color?(self)

        reachable.push(coord)
      end
    end
    reachable
  end

  def legal_regular_moves
    moves = []
    reachable_coordinates.each do |to_coord|
      move = Move.new(coordinate, to_coord)
      mock_board = board.mock_result(move.from_coord.value_array, move.to_coord.value_array)
      next if mock_board.in_check?(color)

      moves.push(move)
    end
    moves
  end
  
  def directions
    directions = []
    offsets.each do |offset|
      length = direction_length
      length = pawn_length(offset) if pawn?
      directions.push(Direction.new(length, coordinate, offset))
    end
    directions
  end

  def pawn_length(offset)
    double_length = 2
    forward_move = [[0, 1], [0, -1]].include?(offset.value_array)
    return direction_length if moved?
    return direction_length unless forward_move

    double_length
  end

  def last_rank?
    return true if color.white? && coordinate.y_value == 7
    return true if color.black? && coordinate.y_value.zero?

    false
  end

  def fifth_rank?
    return true if color.white? && coordinate.y_value == 4
    return true if color.black? && coordinate.y_value == 3

    false
  end

  def same_color?(piece)
    raise "Method 'same_color?' expected ChessPiece object, recieved #{piece}" unless piece.is_a?(ChessPiece)
    return true if piece.color == color

    false
  end

  def opposite_color?(piece)
    raise "Method 'opposite_color?' expected ChessPiece object, recieved #{piece}" unless piece.is_a?(ChessPiece)
    return false if color.nil?
    return true if piece.color != color

    false
  end

  def nil_color?
    return true if color.nil?

    false
  end

  def pawn?() false end
  def king?() false end
  def queen?() false end
  def bishop?() false end
  def knight?() false end
  def rook?() false end
end

class NilPiece < ChessPiece
  attr_reader :color

  def initialize
    @color = nil
  end
end

class Pawn < ChessPiece
  def initialize(color, coordinate, board)
    super
    @offsets = [TOP_LEFT, TOP, TOP_RIGHT]
    black_offsets if color.black?
    @direction_length = 1
    @type = 'pawn'
  end

  def reachable_coordinates
    reachable = []
    directions.each do |direction|
      direction.coordinates.each do |coord|
        break if board.piece_at(coord.x_value, coord.y_value).same_color?(self)

        forward_move = direction.coordinates_array == directions[1].coordinates_array
        if forward_move
          reachable.push(coord) if board.piece_at(coord).nil_color?
          break if moved?
        end

        unless forward_move
          reachable.push(coord) if board.piece_at(coord).opposite_color?(self)
        end
      end
    end
    reachable
  end

  def moved?
    return false if color.white? && coordinate.y_value == 1
    return false if color.black? && coordinate.y_value == 6

    true
  end

  def pawn?
    true
  end
end

class King < ChessPiece
  def initialize(color, coordinate, board)
    super
    @offsets = [LEFT, TOP_LEFT, TOP, TOP_RIGHT, RIGHT, BOT_RIGHT, BOT, BOT_LEFT]
    @direction_length = 1
    @type = 'king'
  end

  def king?
    true
  end
end

class Queen < ChessPiece
  def initialize(color, coordinate, board)
    super
    @offsets = [LEFT, TOP_LEFT, TOP, TOP_RIGHT, RIGHT, BOT_RIGHT, BOT, BOT_LEFT]
    @direction_length = 7
    @type = 'queen'
  end

  def queen?
    true
  end
end

class Bishop < ChessPiece
  def initialize(color, coordinate, board)
    super
    @offsets = [TOP_LEFT, TOP_RIGHT, BOT_RIGHT, BOT_LEFT]
    @direction_length = 7
    @type = 'bishop'
  end

  def bishop?
    true
  end
end

class Knight < ChessPiece
  def initialize(color, coordinate, board)
    super
    @offsets = KNIGHT_OFFSETS
    @direction_length = 1
    @type = 'knight'
  end

  def knight?
    true
  end
end

class Rook < ChessPiece
  def initialize(color, coordinate, board)
    super
    @offsets = [LEFT, TOP, RIGHT, BOT]
    @direction_length = 7
    @type = 'rook'
  end

  def rook?
    true
  end
end

class Direction
  attr_reader :length, :start, :offset

  def initialize(length, start_coordinate, offset)
    @length = length
    @start = start_coordinate
    @offset = offset
  end

  def coordinates
    coordinates = []
    length.times do |count|
      multiplier = count + 1
      new_x_value = start.x_value + (offset.x_value * multiplier)
      new_y_value = start.y_value + (offset.y_value * multiplier)
      new_coord = Coordinate.new(new_x_value, new_y_value)
      break unless new_coord.on_board?

      coordinates.push(new_coord)
    end

    coordinates
  end

  def coordinates_array
    coordinates.map(&:value_array)
  end
end

class Move
  attr_reader :from_coord, :to_coord

  def initialize(from_coord, to_coord)
    @from_coord = from_coord
    @to_coord = to_coord
  end

  def coordinates_array
    [from_coord.value_array, to_coord.value_array]
  end
end