require "./lib/chess_pieces.rb"
require "./lib/chess_moves.rb"
require "./spec_helpers/ChessTestCase.rb"
require "./spec_helpers/input_tester.rb"

describe ChessInput do
  white = WhiteColor.new
  black = BlackColor.new
  let(:board) { double("ChessBoard") }
  let(:window) { double("Window") }
  let(:move_double) { double("Move") }
  let(:manager) { double("ChessManager") }
  before { allow(board).to receive(:manager).and_return(manager) }

  describe "#get_move_object" do
    input_cases = [
      ChessTestCase.new(
        moving_color: black,
        from_alpha_inputs: ["d4"],
        to_alpha_inputs: ["f2"],
        legal_return_values: [true],
        expected_move_coords: [[3, 3], [5, 1]]
      ),
      ChessTestCase.new(
        moving_color: black,
        from_alpha_inputs: %w[k4 a7],
        to_alpha_inputs: ["f2"],
        legal_return_values: [true],
        expected_move_coords: [[0, 6], [5, 1]]
      ),
      ChessTestCase.new(
        moving_color: white,
        from_alpha_inputs: ["b3"],
        to_alpha_inputs: ["d2"],
        legal_return_values: [false, true],
        expected_move_coords: [[1, 2], [3, 1]]
      ),
      ChessTestCase.new(
        moving_color: black,
        from_alpha_inputs: %w[h29 b3],
        to_alpha_inputs: %w[zzk d2],
        legal_return_values: [false, false, false, true],
        expected_move_coords: [[1, 2], [3, 1]]
      ),
      ChessTestCase.new(
        moving_color: white,
        from_alpha_inputs: ["Na3", "", "f4"],
        to_alpha_inputs: %w[KLDFJDcnddfjsf124 1 f7],
        legal_return_values: [true],
        expected_move_coords: [[5, 3], [5, 6]]
      ),
      ChessTestCase.new(
        moving_color: white,
        from_alpha_inputs: %w[9999 0 F4],
        to_alpha_inputs: %w[B 1 F7],
        legal_return_values: [true],
        expected_move_coords: [[5, 3], [5, 6]]
      ),
      ChessTestCase.new(
        moving_color: white,
        from_alpha_inputs: ["h8"],
        to_alpha_inputs: ["h1"],
        legal_return_values: [true],
        expected_move_coords: [[7, 7], [7, 0]]
      ),
      ChessTestCase.new(
        moving_color: black,
        from_alpha_inputs: ["a1"],
        to_alpha_inputs: ["a8"],
        legal_return_values: [true],
        expected_move_coords: [[0, 0], [0, 7]]
      )
    ]

    input_cases.each do |in_case|
      before do
        allow(window).to receive(:setpos)
        allow(window).to receive(:clear)
        allow(window).to receive(:addstr)
        allow(window).to receive(:refresh)
      end
      context color_context(in_case) do
        context from_coord_context(in_case) do
          context to_coord_context(in_case) do
            before do
              allow(board).to receive(:piece_at).and_return(NilPiece.new)
              allow(window).to receive(:getstr).and_return(
                *in_case.from_alpha_inputs,
                *in_case.to_alpha_inputs
              )
            end

            subject(:subject_input) { described_class.new(window) }

            context legal_context(in_case) do
              before { allow_legal(move_double, in_case) }

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
