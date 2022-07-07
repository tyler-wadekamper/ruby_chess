require "./lib/chess_board.rb"
require_relative "ChessTestCase"

describe ChessBoard do
  let(:input) { double("Input") }
  white = WhiteColor.new
  black = BlackColor.new
  colors = [black, white]
  let(:board) { described_class.new(input, colors) }

  sequence_cases = [
    ChessTestCase.new(
      description: "When each side moves a pawn",
      move_arrays: [
        [white, Coordinate.new(3, 1), Coordinate.new(3, 3)],
        [black, Coordinate.new(4, 6), Coordinate.new(4, 4)]
      ],
      next_move: [white, Coordinate.new(3, 3), Coordinate.new(4, 4)],
      expected_legal: true,
      expected: [
        ["Pawn", white, Coordinate.new(3, 3)],
        ["Pawn", black, Coordinate.new(4, 4)]
      ]
    ),
    ChessTestCase.new(
      description: "When en passant is possible on [4, 5]",
      move_arrays: [
        [white, Coordinate.new(3, 1), Coordinate.new(3, 3)],
        [black, Coordinate.new(5, 6), Coordinate.new(5, 4)],
        [white, Coordinate.new(3, 3), Coordinate.new(3, 4)],
        [black, Coordinate.new(4, 6), Coordinate.new(4, 4)]
      ],
      next_move: [white, Coordinate.new(3, 4), Coordinate.new(4, 5)],
      expected_legal: true,
      expected: [
        ["Pawn", white, Coordinate.new(3, 4)],
        ["Pawn", black, Coordinate.new(4, 4)],
        ["Pawn", black, Coordinate.new(5, 4)]
      ]
    ),
    ChessTestCase.new(
      description: "When en passant is completed on [6, 5]",
      move_arrays: [
        [white, Coordinate.new(5, 1), Coordinate.new(5, 3)],
        [black, Coordinate.new(1, 7), Coordinate.new(2, 5)],
        [white, Coordinate.new(5, 3), Coordinate.new(5, 4)],
        [black, Coordinate.new(6, 6), Coordinate.new(6, 4)],
        [white, Coordinate.new(5, 4), Coordinate.new(6, 5)]
      ],
      next_move: [black, Coordinate.new(7, 6), Coordinate.new(6, 5)],
      expected_legal: true,
      expected: [
        ["Pawn", white, Coordinate.new(6, 5)],
        ["Knight", black, Coordinate.new(2, 5)]
      ]
    ),
    ChessTestCase.new(
      description: "When en passant is no longer legal on [4, 5]",
      move_arrays: [
        [white, Coordinate.new(3, 1), Coordinate.new(3, 3)],
        [black, Coordinate.new(5, 6), Coordinate.new(5, 4)],
        [white, Coordinate.new(3, 3), Coordinate.new(3, 4)],
        [black, Coordinate.new(4, 6), Coordinate.new(4, 4)],
        [white, Coordinate.new(4, 1), Coordinate.new(4, 3)],
        [black, Coordinate.new(5, 4), Coordinate.new(4, 3)]
      ],
      next_move: [white, Coordinate.new(3, 4), Coordinate.new(4, 5)],
      expected_legal: false,
      expected: [
        ["Pawn", white, Coordinate.new(3, 4)],
        ["Pawn", black, Coordinate.new(4, 4)],
        ["Pawn", black, Coordinate.new(4, 3)]
      ]
    ),
    # ChessTestCase.new(
    #   description: "When white can castle queenside",
    #   move_arrays: [
    #     [white, Coordinate.new(3, 1), Coordinate.new(3, 3)],
    #     [black, Coordinate.new(3, 6), Coordinate.new(3, 4)],
    #     [white, Coordinate.new(2, 0), Coordinate.new(5, 3)],
    #     [black, Coordinate.new(2, 7), Coordinate.new(3, 6)],
    #     [white, Coordinate.new(1, 0), Coordinate.new(2, 2)],
    #     [black, Coordinate.new(1, 7), Coordinate.new(0, 5)],
    #     [white, Coordinate.new(3, 0), Coordinate.new(3, 2)],
    #     [black, Coordinate.new(3, 7), Coordinate.new(1, 7)]
    #   ],
    #   next_move: [white, Coordinate.new(4, 0), Coordinate.new(2, 0)],
    #   expected_legal: true
    # ),
    ChessTestCase.new(
      description: "When white completes a castle to the queenside",
      move_arrays: [
        [white, Coordinate.new(3, 1), Coordinate.new(3, 3)],
        [black, Coordinate.new(3, 6), Coordinate.new(3, 4)],
        [white, Coordinate.new(2, 0), Coordinate.new(5, 3)],
        [black, Coordinate.new(2, 7), Coordinate.new(3, 6)],
        [white, Coordinate.new(1, 0), Coordinate.new(2, 2)],
        [black, Coordinate.new(1, 7), Coordinate.new(0, 5)],
        [white, Coordinate.new(3, 0), Coordinate.new(3, 2)],
        [black, Coordinate.new(3, 7), Coordinate.new(1, 7)],
        [white, Coordinate.new(4, 0), Coordinate.new(2, 0)]
      ],
      next_move: [black, Coordinate.new(4, 7), Coordinate.new(2, 7)],
      expected_legal: false,
      expected: []
    )
  ]

  sequence_cases.each do |s_case|
    context "#{s_case.description}" do
      before do
        s_case.move_arrays.each do |move_array|
          move = Move.new(move_array[0], move_array[1], move_array[2], board)
          unless move.legal?
            raise "The move from #{move_array[1].value_array} to #{move_array[2].value_array} is not legal"
          end
          board.resolve(move)
        end
        allow(input).to receive(:win)
      end

      describe "move#legal?" do
        it "Returns #{s_case.expected_legal} for the move from #{s_case.next_move[1].value_array} to #{s_case.next_move[2].value_array}" do
          next_move =
            Move.new(
              s_case.next_move[0],
              s_case.next_move[1],
              s_case.next_move[2],
              board
            )
          expect(next_move.legal?).to be(s_case.expected_legal)
        end
      end

      context "After each move has been resolved" do
        it " " do
          output = BoardOutput.new
          output.display_board(board, white, true)
        end

        describe "#piece_at" do
          s_case.expected.each do |piece_array|
            let(:piece) do
              Object.const_get(piece_array[0]).new(
                piece_array[1],
                piece_array[2],
                board
              )
            end

            it "returns #{piece_array[1].name} #{piece_array[0].downcase} on #{piece_array[2].value_array}" do
              expect(board.piece_at(piece.coordinate)).to eq(piece)
            end
          end
        end
      end
    end
  end
end
