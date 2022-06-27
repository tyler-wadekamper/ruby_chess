def color_context(t_case)
  "when initiated with #{t_case.moving_color.name}"
end

def from_coord_context(t_case)
  "given #{t_case.from_alpha_inputs} as from_coord inputs"
end

def to_coord_context(t_case)
  "given #{t_case.to_alpha_inputs} as to_coord inputs"
end

def get_move_object_context(t_case)
  "get_move_object returns the move #{t_case.expected_move_coords}"
end

def legal_context(t_case)
  "and legal? returns #{t_case.legal_return_values}"
end

def allow_legal(move_double, t_case)
  allow(move_double).to receive(:legal?).and_return(*t_case.legal_return_values)
end

def get_move_context(t_case)
  "calls get_move_object #{t_case.legal_return_values.length} time(s)"
end

def execute_get_move(subject_input, move_double, board, t_case)
  allow(subject_input).to receive(:get_move_object).and_return(move_double)

  expect(subject_input).to receive(:get_move_object).exactly(
    t_case.legal_return_values.length
  ).times

  subject_input.move(t_case.moving_color, board)
end

def execute_move_double(subject_input, move_double, board, t_case)
  allow(subject_input).to receive(:get_move_object).and_return(move_double)

  returned_move = subject_input.move(t_case.moving_color, board)

  expect(returned_move).to eq(move_double)
end

def execute_get_move_object(t_case)
  from_x = t_case.expected_move_coords[0][0]
  from_y = t_case.expected_move_coords[0][1]

  to_x = t_case.expected_move_coords[1][0]
  to_y = t_case.expected_move_coords[1][1]

  expected_move =
    Move.new(
      t_case.moving_color,
      Coordinate.new(from_x, from_y),
      Coordinate.new(to_x, to_y),
      board
    )

  actual_move = subject_input.get_move_object(t_case.moving_color, board)

  expect(actual_move).to eq(expected_move)
end
