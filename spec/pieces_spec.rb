require "./lib/chess_pieces.rb"
require_relative "legal_moves_tester"
require_relative "ChessTestCase"

describe ChessPiece do
  white = WhiteColor.new
  black = BlackColor.new
  let(:board) { double("ChessBoard") }

  describe "#legal_regular_moves" do
    legal_moves_cases = [
      ChessTestCase.new(
        subject_piece: ["Pawn", white, Coordinate.new(5, 1)],
        expected: [[5, 2], [5, 3]]
      ),
      ChessTestCase.new(
        subject_piece: ["Pawn", white, Coordinate.new(6, 5)],
        expected: [[6, 6]]
      ),
      ChessTestCase.new(
        subject_piece: ["Pawn", white, Coordinate.new(0, 6)],
        expected: [[0, 7]]
      ),
      ChessTestCase.new(
        subject_piece: ["Pawn", black, Coordinate.new(3, 6)],
        expected: [[3, 5], [3, 4]]
      ),
      ChessTestCase.new(
        subject_piece: ["Pawn", black, Coordinate.new(0, 1)],
        expected: [[0, 0]]
      ),
      ChessTestCase.new(
        subject_piece: ["Pawn", black, Coordinate.new(6, 3)],
        supporting: [["Rook", white, Coordinate.new(6, 2)]],
        expected: []
      ),
      ChessTestCase.new(
        subject_piece: ["Pawn", white, Coordinate.new(5, 2)],
        supporting: [
          ["Pawn", black, Coordinate.new(5, 3)],
          ["Bishop", black, Coordinate.new(6, 3)]
        ],
        expected: [[6, 3]]
      ),
      ChessTestCase.new(
        subject_piece: ["Pawn", black, Coordinate.new(2, 5)],
        supporting: [
          ["Queen", black, Coordinate.new(2, 4)],
          ["Knight", white, Coordinate.new(3, 4)]
        ],
        expected: [[3, 4]]
      ),
      ChessTestCase.new(
        subject_piece: ["Pawn", black, Coordinate.new(1, 6)],
        supporting: [
          ["King", white, Coordinate.new(0, 5)],
          ["Pawn", white, Coordinate.new(2, 5)]
        ],
        expected: [[0, 5], [1, 5], [1, 4], [2, 5]]
      ),
      ChessTestCase.new(
        subject_piece: ["Pawn", white, Coordinate.new(5, 4)],
        supporting: [
          ["Rook", white, Coordinate.new(4, 5)],
          ["Knight", black, Coordinate.new(6, 5)]
        ],
        expected: [[5, 5], [6, 5]]
      ),
      ChessTestCase.new(
        subject_piece: ["Pawn", black, Coordinate.new(5, 6)],
        supporting: [
          ["Rook", black, Coordinate.new(4, 5)],
          ["Queen", black, Coordinate.new(5, 5)],
          ["Pawn", black, Coordinate.new(6, 5)]
        ],
        expected: []
      ),
      ChessTestCase.new(
        subject_piece: ["Pawn", white, Coordinate.new(3, 1)],
        expected: [],
        in_check_coords: [[3, 2], [3, 3]]
      ),
      ChessTestCase.new(
        subject_piece: ["King", white, Coordinate.new(2, 6)],
        expected: [
          [1, 6],
          [1, 7],
          [2, 7],
          [3, 7],
          [3, 6],
          [3, 5],
          [2, 5],
          [1, 5]
        ]
      ),
      ChessTestCase.new(
        subject_piece: ["King", black, Coordinate.new(1, 5)],
        supporting: [
          ["Pawn", black, Coordinate.new(1, 4)],
          ["Pawn", white, Coordinate.new(2, 5)],
          ["Bishop", white, Coordinate.new(7, 0)],
          ["Rook", white, Coordinate.new(0, 6)]
        ],
        expected: [[0, 6], [2, 4]],
        in_check_coords: [[0, 5], [1, 6], [2, 6], [2, 5], [0, 4]]
      ),
      ChessTestCase.new(
        subject_piece: ["King", white, Coordinate.new(7, 4)],
        supporting: [
          ["Queen", black, Coordinate.new(6, 4)],
          ["Rook", black, Coordinate.new(6, 7)]
        ],
        expected: [],
        in_check_coords: [[6, 4], [6, 5], [7, 5], [7, 3], [6, 3], [6, 4]]
      ),
      ChessTestCase.new(
        subject_piece: ["Queen", white, Coordinate.new(2, 2)],
        supporting: [
          ["Rook", black, Coordinate.new(4, 4)],
          ["Knight", black, Coordinate.new(5, 5)]
        ],
        expected: [
          [1, 2],
          [0, 2],
          [1, 3],
          [0, 4],
          [2, 3],
          [2, 4],
          [2, 5],
          [2, 6],
          [2, 7],
          [3, 3],
          [4, 4],
          [3, 2],
          [4, 2],
          [5, 2],
          [6, 2],
          [7, 2],
          [3, 1],
          [4, 0],
          [2, 1],
          [2, 0],
          [1, 1],
          [0, 0]
        ]
      ),
      ChessTestCase.new(
        subject_piece: ["Queen", black, Coordinate.new(0, 7)],
        supporting: [["Pawn", black, Coordinate.new(0, 1)]],
        expected: [
          [1, 7],
          [2, 7],
          [3, 7],
          [4, 7],
          [5, 7],
          [6, 7],
          [7, 7],
          [1, 6],
          [2, 5],
          [3, 4],
          [4, 3],
          [5, 2],
          [6, 1],
          [7, 0],
          [0, 6],
          [0, 5],
          [0, 4],
          [0, 3],
          [0, 2]
        ]
      ),
      ChessTestCase.new(
        subject_piece: ["Bishop", black, Coordinate.new(1, 2)],
        supporting: [
          ["Pawn", black, Coordinate.new(3, 0)],
          ["Pawn", white, Coordinate.new(4, 5)],
          ["Pawn", white, Coordinate.new(5, 6)]
        ],
        expected: [[0, 3], [2, 3], [3, 4], [4, 5], [2, 1], [0, 1]]
      ),
      ChessTestCase.new(
        subject_piece: ["Knight", white, Coordinate.new(5, 5)],
        supporting: [
          ["Pawn", black, Coordinate.new(7, 6)],
          ["Pawn", white, Coordinate.new(7, 4)]
        ],
        expected: [[3, 6], [4, 7], [6, 7], [7, 6], [6, 3], [4, 3], [3, 4]]
      ),
      ChessTestCase.new(
        subject_piece: ["Rook", black, Coordinate.new(6, 1)],
        supporting: [
          ["Pawn", black, Coordinate.new(4, 1)],
          ["Pawn", white, Coordinate.new(6, 7)]
        ],
        expected: [
          [5, 1],
          [6, 2],
          [6, 3],
          [6, 4],
          [6, 5],
          [6, 6],
          [6, 7],
          [7, 1],
          [6, 0]
        ]
      )
    ]

    legal_moves_cases.each do |lm_case|
      context supporting_context(lm_case) do
        before { allow_supporting(board, lm_case) }

        context check_context(lm_case).to_s do
          before { allow_check(board, lm_case) }

          subject(:subject_piece) do
            Object.const_get(lm_case.subject_piece[0]).new(
              lm_case.subject_piece[1],
              lm_case.subject_piece[2],
              board
            )
          end

          context piece_string(lm_case.subject_piece).to_s do
            move_array_string = expected_moves_string(lm_case)
            let(:move_array) { expected_moves(lm_case, board) }

            it "returns the moves #{move_array_string}" do
              piece_execute_it(subject_piece, move_array)
            end
          end
        end
      end
    end
  end
end
