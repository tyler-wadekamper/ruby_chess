class ChessTestCase
  attr_reader :description,
              :subject_piece,
              :supporting,
              :moving_color,
              :to_coord,
              :in_check_coords,
              :expected,
              :expected_legal,
              :in_legal_regular,
              :start_in_check,
              :first_supporting_last_moved_two,
              :from_alpha_inputs,
              :to_alpha_inputs,
              :legal_return_values,
              :expected_move_coords,
              :move_arrays,
              :in_check,
              :stalemate,
              :checkmate,
              :insufficient_material

  def initialize(
    description: "",
    subject_piece: [],
    supporting: [],
    moving_color: nil,
    to_coord: [],
    in_check_coords: [],
    expected: [],
    expected_legal: nil,
    in_legal_regular: false,
    start_in_check: false,
    first_supporting_last_moved_two: false,
    from_alpha_inputs: [],
    to_alpha_inputs: [],
    legal_return_values: [],
    expected_move_coords: [],
    move_arrays: [],
    in_check: nil,
    stalemate: false,
    checkmate: nil,
    insufficient_material: false
  )
    @description = description
    @subject_piece = subject_piece
    @supporting = supporting
    @moving_color = moving_color
    @to_coord = to_coord
    @in_check_coords = in_check_coords
    @expected = expected
    @expected_legal = expected_legal
    @in_legal_regular = in_legal_regular
    @start_in_check = start_in_check
    @first_supporting_last_moved_two = first_supporting_last_moved_two
    @from_alpha_inputs = from_alpha_inputs
    @to_alpha_inputs = to_alpha_inputs
    @legal_return_values = legal_return_values
    @expected_move_coords = expected_move_coords
    @move_arrays = move_arrays
    @in_check = in_check
    @stalemate = stalemate
    @checkmate = checkmate
    @insufficient_material = insufficient_material
  end
end
