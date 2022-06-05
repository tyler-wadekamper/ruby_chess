require "./lib/chess_pieces.rb"
require "./lib/chess_moves.rb"
require "./spec/legal_moves_tester.rb"
require "./spec/ChessTestCase.rb"

describe Move do
  white = WhiteColor.new
  black = BlackColor.new
  let(:board) { double("ChessBoard") }

  describe "#legal?" do
    move_cases = [
      MoveCase.new(
        description: "the move is in legal_regular_moves",
        moving_color: black,
        subject_piece: ["Pawn", black, Coordinate.new(4, 1)],
        to_coord: Coordinate.new(4, 0),
        supporting: [["Pawn", white, Coordinate.new(3, 0)]],
        in_legal_regular: true,
        expected_legal: true
      ),
      MoveCase.new(
        description: "the move is not in legal_regular_moves",
        moving_color: black,
        subject_piece: ["Pawn", black, Coordinate.new(4, 1)],
        to_coord: Coordinate.new(4, 0),
        supporting: [["King", white, Coordinate.new(4, 0)]],
        expected_legal: false
      ),
      MoveCase.new(
        description: "white attempts to move black piece",
        moving_color: white,
        subject_piece: ["Pawn", black, Coordinate.new(4, 1)],
        to_coord: Coordinate.new(4, 0),
        in_legal_regular: true,
        expected_legal: false
      ),
      MoveCase.new(
        description: "a legal kingside castle",
        moving_color: black,
        subject_piece: ["King", black, Coordinate.new(4, 7)],
        to_coord: Coordinate.new(6, 7),
        supporting: [["Rook", black, Coordinate.new(7, 7)]],
        expected_legal: true
      ),
      MoveCase.new(
        description: "a knight blocks the kingside castle",
        moving_color: black,
        subject_piece: ["King", black, Coordinate.new(4, 7)],
        to_coord: Coordinate.new(6, 7),
        supporting: [
          ["Rook", black, Coordinate.new(7, 0)],
          ["Knight", black, Coordinate.new(6, 7)]
        ],
        expected_legal: false
      ),
      MoveCase.new(
        description: "a legal queenside castle",
        moving_color: black,
        subject_piece: ["King", black, Coordinate.new(4, 7)],
        to_coord: Coordinate.new(2, 7),
        supporting: [
          ["Rook", black, Coordinate.new(0, 7)],
          ["Knight", black, Coordinate.new(6, 7)]
        ],
        expected_legal: true
      ),
      MoveCase.new(
        description: "the queen blocks the queenside castle",
        moving_color: black,
        subject_piece: ["King", black, Coordinate.new(4, 7)],
        to_coord: Coordinate.new(2, 7),
        supporting: [
          ["Rook", black, Coordinate.new(0, 7)],
          ["Queen", black, Coordinate.new(3, 7)]
        ],
        expected_legal: false
      ),
      MoveCase.new(
        description: "the king is not in the correct square",
        moving_color: black,
        subject_piece: ["NilPiece", nil, Coordinate.new(4, 7)],
        to_coord: Coordinate.new(6, 7),
        supporting: [
          ["King", black, Coordinate.new(3, 7)],
          ["Rook", black, Coordinate.new(7, 0)]
        ],
        expected_legal: false
      ),
      MoveCase.new(
        description: "a knight is in the king square",
        moving_color: black,
        subject_piece: ["Knight", black, Coordinate.new(4, 7)],
        to_coord: Coordinate.new(6, 7),
        supporting: [["Rook", black, Coordinate.new(7, 0)]],
        expected_legal: false
      ),
      MoveCase.new(
        description: "the king has moved",
        moving_color: black,
        subject_piece: ["King", black, Coordinate.new(4, 7), true],
        to_coord: Coordinate.new(2, 7),
        supporting: [["Rook", black, Coordinate.new(0, 7)]],
        expected_legal: false
      ),
      MoveCase.new(
        description: "the rook has moved",
        moving_color: black,
        subject_piece: ["King", black, Coordinate.new(4, 7)],
        to_coord: Coordinate.new(2, 7),
        supporting: [["Rook", black, Coordinate.new(0, 7), true]],
        expected_legal: false
      ),
      MoveCase.new(
        description: "the to_coord is not correct for castle",
        moving_color: black,
        subject_piece: ["King", black, Coordinate.new(4, 7)],
        to_coord: Coordinate.new(1, 7),
        supporting: [["Rook", black, Coordinate.new(0, 7)]],
        expected_legal: false
      ),
      MoveCase.new(
        description: "the from_coord is not correct for castle",
        moving_color: black,
        subject_piece: ["NilPiece", black, Coordinate.new(3, 7)],
        to_coord: Coordinate.new(1, 7),
        supporting: [["Rook", black, Coordinate.new(0, 7)]],
        expected_legal: false
      ),
      MoveCase.new(
        description: "the corner square is empty",
        moving_color: black,
        subject_piece: ["King", black, Coordinate.new(4, 7)],
        to_coord: Coordinate.new(2, 7),
        expected_legal: false
      ),
      MoveCase.new(
        description: "the corner piece is not a rook",
        moving_color: black,
        subject_piece: ["King", black, Coordinate.new(4, 7)],
        to_coord: Coordinate.new(6, 7),
        supporting: [["Queen", black, Coordinate.new(7, 0)]],
        expected_legal: false
      ),
      MoveCase.new(
        description: "the king would move through check on [5, 7]",
        moving_color: black,
        subject_piece: ["King", black, Coordinate.new(4, 7)],
        to_coord: Coordinate.new(6, 7),
        supporting: [["Rook", black, Coordinate.new(7, 0)]],
        in_check_coords: [[5, 7]],
        expected_legal: false
      ),
      MoveCase.new(
        description: "the king would move to check on [2, 7]",
        moving_color: black,
        subject_piece: ["King", black, Coordinate.new(4, 7)],
        to_coord: Coordinate.new(2, 7),
        supporting: [["Rook", black, Coordinate.new(0, 7)]],
        in_check_coords: [[2, 7]],
        expected_legal: false
      ),
      MoveCase.new(
        description: "the king is in check",
        moving_color: black,
        subject_piece: ["King", black, Coordinate.new(4, 7)],
        to_coord: Coordinate.new(2, 7),
        supporting: [["Rook", black, Coordinate.new(0, 7)]],
        start_in_check: true,
        expected_legal: false
      ),
      MoveCase.new(
        description: "a legal kingside castle",
        moving_color: white,
        subject_piece: ["King", white, Coordinate.new(4, 0)],
        to_coord: Coordinate.new(6, 0),
        supporting: [["Rook", white, Coordinate.new(7, 0)]],
        expected_legal: true
      ),
      MoveCase.new(
        description: "a knight blocks the kingside castle",
        moving_color: white,
        subject_piece: ["King", white, Coordinate.new(4, 0)],
        to_coord: Coordinate.new(6, 0),
        supporting: [
          ["Rook", white, Coordinate.new(7, 0)],
          ["Knight", white, Coordinate.new(5, 0)]
        ],
        expected_legal: false
      ),
      MoveCase.new(
        description: "a legal queenside castle",
        moving_color: white,
        subject_piece: ["King", white, Coordinate.new(4, 0)],
        to_coord: Coordinate.new(2, 0),
        supporting: [["Rook", white, Coordinate.new(0, 0)]],
        expected_legal: true
      ),
      MoveCase.new(
        description: "a bishop blocks the queenside castle",
        moving_color: white,
        subject_piece: ["King", white, Coordinate.new(4, 0)],
        to_coord: Coordinate.new(2, 0),
        supporting: [
          ["Bishop", black, Coordinate.new(3, 0)],
          ["Rook", white, Coordinate.new(0, 0)]
        ],
        expected_legal: false
      ),
      MoveCase.new(
        description: "the king is not in the correct square",
        moving_color: white,
        subject_piece: ["NilPiece", nil, Coordinate.new(4, 0)],
        to_coord: Coordinate.new(6, 0),
        supporting: [
          ["King", white, Coordinate.new(4, 1)],
          ["Rook", white, Coordinate.new(7, 0)]
        ],
        expected_legal: false
      ),
      MoveCase.new(
        description: "a bishop is in the king square",
        moving_color: white,
        subject_piece: ["Bishop", white, Coordinate.new(4, 0)],
        to_coord: Coordinate.new(2, 0),
        supporting: [["Rook", white, Coordinate.new(0, 0)]],
        expected_legal: false
      ),
      MoveCase.new(
        description: "the king has moved",
        moving_color: white,
        subject_piece: ["King", white, Coordinate.new(4, 0), true],
        to_coord: Coordinate.new(6, 0),
        supporting: [["Rook", white, Coordinate.new(7, 0)]],
        expected_legal: false
      ),
      MoveCase.new(
        description: "the rook has moved",
        moving_color: white,
        subject_piece: ["King", white, Coordinate.new(4, 0)],
        to_coord: Coordinate.new(2, 0),
        supporting: [["Rook", white, Coordinate.new(0, 0), true]],
        expected_legal: false
      ),
      MoveCase.new(
        description: "the to_coord is not correct for castle",
        moving_color: white,
        subject_piece: ["King", white, Coordinate.new(4, 0)],
        to_coord: Coordinate.new(7, 0),
        supporting: [["Rook", white, Coordinate.new(7, 0)]],
        expected_legal: false
      ),
      MoveCase.new(
        description: "the from_coord is not correct for castle",
        moving_color: white,
        subject_piece: ["King", white, Coordinate.new(3, 0), true],
        to_coord: Coordinate.new(6, 0),
        supporting: [["Rook", white, Coordinate.new(7, 0)]],
        expected_legal: false
      ),
      MoveCase.new(
        description: "the corner square is empty",
        moving_color: white,
        subject_piece: ["King", white, Coordinate.new(4, 0)],
        to_coord: Coordinate.new(2, 0),
        expected_legal: false
      ),
      MoveCase.new(
        description: "the corner piece is not a rook",
        moving_color: white,
        subject_piece: ["King", white, Coordinate.new(4, 0)],
        to_coord: Coordinate.new(6, 0),
        supporting: [["Queen", white, Coordinate.new(7, 0)]],
        expected_legal: false
      ),
      MoveCase.new(
        description: "the king would to through check on [6, 0]",
        moving_color: white,
        subject_piece: ["King", white, Coordinate.new(4, 0)],
        to_coord: Coordinate.new(6, 0),
        supporting: [["Rook", white, Coordinate.new(7, 0)]],
        in_check_coords: [[6, 0]],
        expected_legal: false
      ),
      MoveCase.new(
        description: "the king would move through check on [3, 0]",
        moving_color: white,
        subject_piece: ["King", white, Coordinate.new(4, 0)],
        to_coord: Coordinate.new(2, 0),
        supporting: [["Rook", white, Coordinate.new(0, 0)]],
        in_check_coords: [[3, 0]],
        expected_legal: false
      ),
      MoveCase.new(
        description: "the king is in check",
        moving_color: white,
        subject_piece: ["King", white, Coordinate.new(4, 0)],
        to_coord: Coordinate.new(2, 0),
        supporting: [["Rook", white, Coordinate.new(0, 0)]],
        start_in_check: true,
        expected_legal: false
      ),
      MoveCase.new(
        description: "legal en passant",
        moving_color: white,
        subject_piece: ["Pawn", white, Coordinate.new(4, 4)],
        to_coord: Coordinate.new(3, 5),
        supporting: [["Pawn", black, Coordinate.new(3, 4)]],
        first_supporting_last_moved_two: true,
        expected_legal: true
      ),
      MoveCase.new(
        description: "legal en passant",
        moving_color: white,
        subject_piece: ["Pawn", white, Coordinate.new(0, 4)],
        to_coord: Coordinate.new(1, 5),
        supporting: [["Pawn", black, Coordinate.new(1, 4)]],
        first_supporting_last_moved_two: true,
        expected_legal: true
      ),
      MoveCase.new(
        description: "legal en passant",
        moving_color: black,
        subject_piece: ["Pawn", black, Coordinate.new(5, 3)],
        to_coord: Coordinate.new(6, 2),
        supporting: [["Pawn", white, Coordinate.new(6, 3)]],
        first_supporting_last_moved_two: true,
        expected_legal: true
      ),
      MoveCase.new(
        description: "no adjacent piece for en passant",
        moving_color: black,
        subject_piece: ["Pawn", black, Coordinate.new(2, 3)],
        to_coord: Coordinate.new(1, 2),
        expected_legal: false
      ),
      MoveCase.new(
        description: "the attacking piece for en passant is not a pawn",
        moving_color: black,
        subject_piece: ["Knight", black, Coordinate.new(4, 3)],
        to_coord: Coordinate.new(5, 2),
        supporting: [["Pawn", white, Coordinate.new(5, 3)]],
        first_supporting_last_moved_two: true,
        expected_legal: false
      ),
      MoveCase.new(
        description:
          "the adjacent pawn wasn't the last to move forward two spaces",
        moving_color: white,
        subject_piece: ["Pawn", white, Coordinate.new(7, 4)],
        to_coord: Coordinate.new(6, 5),
        supporting: [
          ["Pawn", black, Coordinate.new(5, 4)],
          ["Pawn", black, Coordinate.new(6, 4)]
        ],
        first_supporting_last_moved_two: true,
        expected_legal: false
      ),
      MoveCase.new(
        description: "the attacked piece is not a pawn",
        moving_color: white,
        subject_piece: ["Pawn", white, Coordinate.new(4, 4)],
        to_coord: Coordinate.new(3, 5),
        supporting: [["Bishop", black, Coordinate.new(3, 4)]],
        expected_legal: false
      ),
      MoveCase.new(
        description: "the adjacent pawn is of the same color",
        moving_color: black,
        subject_piece: ["Pawn", black, Coordinate.new(5, 3)],
        to_coord: Coordinate.new(6, 2),
        supporting: [["Pawn", black, Coordinate.new(6, 3)]],
        expected_legal: false
      ),
      MoveCase.new(
        description: "the attacking pawn is not on the fifth rank",
        moving_color: black,
        subject_piece: ["Pawn", black, Coordinate.new(5, 2)],
        to_coord: Coordinate.new(6, 1),
        supporting: [["Pawn", black, Coordinate.new(6, 2)]],
        expected_legal: false
      ),
      MoveCase.new(
        description: "backwards en passant attempt",
        moving_color: white,
        subject_piece: ["Pawn", white, Coordinate.new(0, 4)],
        to_coord: Coordinate.new(1, 3),
        supporting: [["Pawn", black, Coordinate.new(1, 4)]],
        first_supporting_last_moved_two: true,
        expected_legal: false
      )
    ]

    move_cases.each do |mv_case|
      context subject_supporting_context(mv_case.hash) do
        before do
          allow_supporting(board, mv_case.hash)
          allow_subject(board, mv_case.hash)
        end

        context check_context(mv_case.hash) do
          before { allow_check(board, mv_case.hash) }

          context board_check_context(mv_case.hash) do
            before { allow_board_check(board, mv_case.hash) }

            subject(:subject_move) do
              described_class.new(
                mv_case.hash[:moving_color],
                mv_case.hash[:subject_piece][2],
                mv_case.hash[:to_coord],
                board
              )
            end

            context legal_context(mv_case.hash) do
              context move_string(mv_case.hash) do
                it "returns #{mv_case.hash[:expected_legal]} - #{mv_case.hash[:description]}" do
                  move_execute_it(subject_move, mv_case.hash)
                end
              end
            end
          end
        end
      end
    end
  end
end
