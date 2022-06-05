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
              :first_supporting_last_moved_two

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
    first_supporting_last_moved_two: false
  )
    @description = description
    @subject_piece = subject_piece
    @supporting = supporting
    @moving_color = moving_color
    @to_coord = to_coord
    @in_check_coords = in_check_coords
  end

  def hash()
    {
      description: description,
      subject_piece: subject_piece,
      supporting: supporting,
      moving_color: moving_color,
      to_coord: to_coord,
      in_check_coords: in_check_coords,
      expected: expected,
      expected_legal: expected_legal,
      in_legal_regular: in_legal_regular,
      start_in_check: start_in_check,
      first_supporting_last_moved_two: first_supporting_last_moved_two
    }
  end
end

class PieceCase < ChessTestCase
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
    first_supporting_last_moved_two: false
  )
    super
    @expected = expected
  end
end

class MoveCase < ChessTestCase
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
    first_supporting_last_moved_two: false
  )
    super
    @expected_legal = expected_legal
    @in_legal_regular = in_legal_regular
    @start_in_check = start_in_check
    @first_supporting_last_moved_two = first_supporting_last_moved_two
  end
end
