def supporting_context(supporting_pieces)
  return 'with an empty board' if supporting_pieces.empty?

  length = supporting_pieces.length

  context = 'with '
  supporting_pieces.each do |piece_info|
    context += 'and ' if piece_info == supporting_pieces.last && length > 1
    context += to_string(piece_info[1].name, piece_info[0].downcase, piece_info[2])
    context += ', ' unless piece_info == supporting_pieces.last
  end
  context
end

def allow_supporting(board_double, supporting_pieces)
  allow(board_double).to receive(:piece_at).and_return(NilPiece.new)

  supporting_pieces.each_with_index do |piece_info|
    piece = Object.const_get(piece_info[0]).new(piece_info[1], piece_info[2], board_double)
    allow(board_double).to receive(:piece_at).with(piece.coordinate.value_array).and_return(piece)
  end
end

def check_context(in_check_to_coords, subject_coord)
  return 'when no moves result in own check' if in_check_to_coords.empty?

  in_check_moves = move_coord_array(subject_coord.value_array, in_check_to_coords)

  context = 'when '
  length = in_check_moves.length
  in_check_moves.each do |move|
    context += 'the moves ' if length > 1 && move == in_check_moves.first
    context += 'the move ' if length == 1 && move == in_check_moves.first
    context += 'and ' if move == in_check_moves.last && length > 1
    context += "#{move}"
    context += ', ' unless move == in_check_moves.last
  end
  context + ' result in own check'
end

def allow_check(board_double, subject_coord, in_check_to_coords)
  check_board = double('Check Board')
  no_check_board = double('No Check Board')

  allow(board_double).to receive(:mock_result).and_return(no_check_board)

  in_check_to_coords.each do |to_coord|
    allow(board_double).to receive(:mock_result).with(subject_coord.value_array, to_coord).and_return(check_board)
  end

  allow(check_board).to receive(:in_check?).and_return(true)
  allow(no_check_board).to receive(:in_check?).and_return(false)
end

def expected_moves(subject_coord, expected_to_coords)
  return [] if expected_to_coords.empty?

  expected = []
  expected_to_coords.each do |to_coord_value_array|
    expected.push([subject_coord.value_array, to_coord_value_array])
  end
  expected
end

def it_string(move_array)
  return "returns an empty array" if move_array.empty?

  "returns the moves #{move_array}"
end

def execute_it(test_subject, move_array)
  subject_moves = test_subject.legal_regular_moves

  move_values = subject_moves.map(&:coordinates_array)
  expect(move_values).to eq(move_array)
end

def to_string(color, type, subject_coord)
  "a #{color} #{type} on #{subject_coord.to_alpha_string}"
end

def move_coord_array(from_coord_value_array, to_coord_value_array)
  result_array = []
  to_coord_value_array.each do |to_coord|
    result_array.push([from_coord_value_array, to_coord])
  end
  result_array
end