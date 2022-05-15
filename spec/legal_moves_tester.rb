require './lib/chess_pieces.rb'

class LegalMovesTester
  def initialize
    @subject_piece = nil
    @supporting_pieces = nil
    @expected_to_coords = nil
    @in_check_to_coords = nil
    @board_double = nil
    @it_string = nil
  end

  def test(subject_piece, supporting_pieces, expected_to_coords, in_check_to_coords, board_double)
    set_attributes(subject_piece, supporting_pieces, expected_to_coords, in_check_to_coords, board_double)
    
    context "#{supporting_context}" do
      allow_supporting

      context "#{check_context}" do
        allow_check

        context "#{to_string(subject_piece)}" do
          test_subject = create_subject
          move_array = expected_moves
          it_heading = it_string(move_array)

          execute_it(test_subject, move_array, it_heading)
        end
      end
    end
  end

  private

  attr_accessor :subject_piece, :supporting_pieces, :expected_to_coords,
              :in_check_to_coords, :board_double, :it_string

  def set_attributes(subject_piece, supporting_pieces, expected_to_coords, in_check_to_coords, board_double)
    @subject_piece = subject_piece
    @supporting_pieces = supporting_pieces
    @expected_to_coords = expected_to_coords
    @in_check_to_coords = in_check_to_coords
    @board_double = board_double
  end

  def supporting_context
    return 'with an empty board' if supporting_pieces.nil?

    context = 'with'
    supporting_pieces.each do |piece|
      context += 'and' if piece == supporting_pieces.last
      context += to_string(piece)
      context += ',' unless piece == supporting_pieces.last
    end
    context
  end

  def allow_supporting
    recorded_coords = []

    supporting_pieces.each_with_index do |piece, index|
      piece_symbol = "piece#{index}".to_sym
      let(piece_symbol) { piece }
      piece_x = piece.coordinate.x_value
      piece_y = piece.coordinate.y_value
      allow(board_double).to receive(piece_x, piece_y).and_return(piece_symbol)
      recorded_coords.push([piece_x, piece_y])
    end

    let(:nil_piece) { NilPiece.new }

    8.times do |x_val|
      8.times do |y_val|
        unless recorded_coords.include?([x_val, y_val])
          allow(board_double).to receive(x_val, y_val).and_return(nil_piece)
        end
      end
    end
  end
  
  def check_context
    return 'when no moves result in own check' if in_check_to_coords.nil?

    in_check_moves = move_coord_array(subject_piece.coordinate.value_array, in_check_to_coords)

    context = 'when '
    length = in_check_moves.length
    in_check_moves.each do |move|
      context += 'the moves ' if length > 1
      context += 'the move ' if length == 1
      context += 'and ' if move == in_check_moves.last && length > 1
      context += "#{move.coordinates_array} "
      context += ', ' unless move == in_check_moves.last
    end
    context + 'result in own check'
  end

  def allow_check
    from_coord = subject_piece.coordinate

    let(:check_board) { double('Check Board') }
    let(:no_check_board) { double('No Check Board') }

    recorded_coord_values = []
    in_check_to_coords.each do |to_coord|
      allow(board_double).to receive(:mock_result).with(from_coord.value_array, to_coord.value_array).and_return(check_board)
      recorded_coord_values += [from_coord.value_array, to_coord.value_array]
    end

    all_coords = []
    8.times do |x_val|
      8.times do |y_val|
        all_coords.push(Coordinate.new(x_val, y_val))
      end
    end

    all_moves = []
    all_coords.each do |coord1|
      all_coords.each do |coord2|
        next if coord1 == coord2
        next if recorded_coord_values.include?([coord1.value_array, coord2.value_array])

        allow(board_double).to receive(:mock_result).with(coord1.value_array, coord2.value_array).and_return(no_check_board)
      end
    end

    allow(board_double).to receive(:in_check?).with(check_board).and_return(true)
    allow(board_double).to receive(:in_check?).with(no_check_board).and_return(false)
  end

  def create_subject
    subject(:piece) { subject_piece }
    piece
  end

  def expected_moves
    return []] if expected_to_coords.nil?

    expected = []
    expected_to_coords.each do |to_coord|
      expected.push(move_coord_array(subject_piece.coordinate.value_array, to_coord))
    end
    expected
  end

  def it_string(move_array)
    return "returns an empty array" if move_array.empty?

    "returns the moves #{move_array}"
  end
  
  def execute_it(test_subject, move_array, it_heading)
    
  end

  def to_string(piece)
    "a #{piece.color} #{piece.type} on #{piece.coordinate.to_alpha_string}"
  end

  def move_coord_array(from_coord_value_array, to_coord_value_array)
    result_array = []
    to_coord_value_array.each do |to_coord|
      result_array.push([from_coord_value_array, to_coord])
    end
    result_array
  end
end