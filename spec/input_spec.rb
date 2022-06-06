require "./lib/chess_pieces.rb"
require "./lib/chess_moves.rb"
require "./spec/ChessTestCase.rb"
require "./spec/input_tester.rb"

describe ChessInput do
  white = WhiteColor.new
  black = BlackColor.new
  let(:board) { double("ChessBoard") }
  let(:move_double) { double("Move") }

  describe "#move" do
    input_cases = [
      InputCase.new(
        moving_color: black,
        from_alpha_inputs: ["d4\n"],
        to_alpha_inputs: ["f2\n"],
        legal_return_values: [true],
        expected_move_coords: [[3, 3], [5, 1]]
      ),
      InputCase.new(
        moving_color: black,
        from_alpha_inputs: ["k4\n", "a7\n"],
        to_alpha_inputs: ["f2\n"],
        legal_return_values: [true],
        expected_move_coords: [[0, 6], [5, 1]]
      ),
      InputCase.new(
        moving_color: white,
        from_alpha_inputs: ["b3\n"],
        to_alpha_inputs: ["d2\n"],
        legal_return_values: [false, true],
        expected_move_coords: [[1, 2], [3, 1]]
      ),
      InputCase.new(
        moving_color: black,
        from_alpha_inputs: ["h29\n", "b3\n"],
        to_alpha_inputs: ["zzk\n", "d2\n"],
        legal_return_values: [false, false, false, true],
        expected_move_coords: [[1, 2], [3, 1]]
      ),
      InputCase.new(
        moving_color: white,
        from_alpha_inputs: ["Na3\n", "\n", "f4\n"],
        to_alpha_inputs: ["KLDFJDcnddfjsf124\n", "1\n", "f7\n"],
        legal_return_values: [true],
        expected_move_coords: [[5, 3], [5, 6]]
      ),
      InputCase.new(
        moving_color: white,
        from_alpha_inputs: ["9999\n", "0\n", "F4\n"],
        to_alpha_inputs: ["B\n", "1\n", "F7\n"],
        legal_return_values: [true],
        expected_move_coords: [[5, 3], [5, 6]]
      )
    ]

    input_cases.each do |in_case|
      context color_context(in_case) do
        context from_coord_context(in_case) do
          context to_coord_context(in_case) do
            before do
              allow_gets(in_case)
              allow(board).to receive(:piece_at).and_return(NilPiece.new)
            end

            subject(:subject_input) { described_class.new }

            context legal_context(in_case) do
              before { allow_legal(move_double, in_case) }

              it get_move_context(in_case) do
                execute_get_move(subject_input, move_double, board, in_case)
              end

              it "returns the move_double object" do
                execute_move_double(subject_input, move_double, board, in_case)
              end

              it get_move_object_context(in_case) do
                execute_get_move_object(in_case)
              end
            end
          end
        end
      end
    end
  end
end
