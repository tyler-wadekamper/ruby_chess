def supporting_context(t_case)
  supporting_pieces = t_case[:supporting]

  return "with an empty board" if supporting_pieces.empty?

  length = supporting_pieces.length

  context = "with "
  supporting_pieces.each do |piece_info|
    context += "and " if piece_info == supporting_pieces.last && length > 1
    context += piece_string(piece_info)
    context += ", " unless piece_info == supporting_pieces.last
  end
  context
end

def subject_supporting_context(t_case)
  "#{subject_context(t_case)} #{supporting_context(t_case)}"
end

def subject_context(t_case)
  subject_piece = t_case[:subject_piece]

  piece_string(subject_piece)
end

def allow_supporting(board_double, t_case)
  supporting_pieces = t_case[:supporting]
  first_supporting_last_moved_two = t_case[:first_supporting_last_moved_two]

  (0..7).each do |x|
    (0..7).each do |y|
      allow(board_double).to receive(:piece_at).with([x, y]).and_return(
        NilPiece.new(Coordinate.new(x, y))
      )
    end
  end

  supporting_pieces.map! { |piece_info| allow_piece(board_double, piece_info) }

  if first_supporting_last_moved_two
    allow_last_moved_two(board_double, supporting_pieces[0])
  end
end

def allow_last_moved_two(board_double, first_supporting_piece)
  allow(board_double).to receive(:last_moved_two).and_return(
    first_supporting_piece
  )
end

def allow_subject(board_double, t_case)
  allow_piece(board_double, t_case[:subject_piece])
end

def allow_piece(board_double, piece_info)
  moved = false unless piece_info.length > 3
  moved = piece_info[3] if piece_info.length > 3

  return if piece_info[0] == "NilPiece"

  piece =
    Object.const_get(piece_info[0]).new(
      piece_info[1],
      piece_info[2],
      board_double,
      moved
    )
  allow(board_double).to receive(:piece_at).with(
    piece.coordinate.value_array
  ).and_return(piece)
  piece
end

def check_context(t_case)
  in_check_to_coords = t_case[:in_check_coords]
  subject_coord = t_case[:subject_piece][2]

  if in_check_to_coords.empty?
    return "when the move does not result in own check"
  end

  in_check_moves =
    move_coord_array(subject_coord.value_array, in_check_to_coords)

  context = "when "
  length = in_check_moves.length
  in_check_moves.each do |move|
    context += "the moves " if length > 1 && move == in_check_moves.first
    context += "the move " if length == 1 && move == in_check_moves.first
    context += "and " if move == in_check_moves.last && length > 1
    context += "#{move}"
    context += ", " unless move == in_check_moves.last
  end
  context + " result in own check"
end

def allow_check(board_double, t_case)
  in_check_to_coords = t_case[:in_check_coords]
  subject_coord = t_case[:subject_piece][2]

  check_board = double("Check Board")
  no_check_board = double("No Check Board")

  allow(board_double).to receive(:mock_result).and_return(no_check_board)

  in_check_to_coords.each do |to_coord|
    allow(board_double).to receive(:mock_result).with(
      subject_coord.value_array,
      to_coord
    ).and_return(check_board)
  end

  allow(check_board).to receive(:in_check?).and_return(true)
  allow(no_check_board).to receive(:in_check?).and_return(false)
end

def expected_moves(t_case)
  subject_coord = t_case[:subject_piece][2]
  expected_to_coords = t_case[:expected]

  return [] if expected_to_coords.empty?

  expected = []
  expected_to_coords.each do |to_coord_value_array|
    expected.push([subject_coord.value_array, to_coord_value_array])
  end
  expected
end

def piece_it_string(move_array)
  return "returns an empty array" if move_array.empty?

  "returns the moves #{move_array}"
end

def piece_execute_it(test_subject, move_array)
  subject_moves = test_subject.legal_regular_moves

  move_values = subject_moves.map(&:coordinates_array)
  expect(move_values).to eq(move_array)
end

def move_execute_it(test_subject, t_case)
  legal_move = test_subject.legal?

  expect(legal_move).to eq(t_case[:expected_legal])
end

def piece_string(piece_info)
  return "" if piece_info[0] == "NilPiece"

  color = piece_info[1].name
  type = piece_info[0].downcase
  subject_coord = piece_info[2]

  "a #{color} #{type} on #{subject_coord.value_array}"
end

def legal_context(t_case)
  return "and the move is in legal_regular_moves" if t_case[:in_legal_regular]

  "and the move is not in legal_regular_moves"
end

def move_string(t_case)
  color = t_case[:moving_color].name
  to_coord = t_case[:to_coord]
  subject_coord = t_case[:subject_piece][2]

  "a #{color} move from #{subject_coord.value_array} to #{to_coord.value_array}"
end

def move_coord_array(from_coord_value_array, to_coord_value_array)
  result_array = []
  to_coord_value_array.each do |to_coord|
    result_array.push([from_coord_value_array, to_coord])
  end
  result_array
end

def board_check_context(t_case)
  in_check = t_case[:start_in_check]
  return "the king is currently in check" if in_check

  "the king is not currently in check"
end

def allow_board_check(board_double, t_case)
  in_check = t_case[:start_in_check]

  allow(board_double).to receive(:in_check?).and_return(in_check)
end
