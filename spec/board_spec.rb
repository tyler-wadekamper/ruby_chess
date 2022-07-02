require "./lib/chess_board.rb"
require "./lib/chess_input.rb"
require "./lib/chess_pieces.rb"
require_relative "ChessTestCase"

describe ChessBoard do
  let(:input) { double("Input") }
  white = WhiteColor.new
  black = BlackColor.new
  colors = [black, white]
  let(:board) { described_class.new(input, colors) }

  context "with initial board setup" do
    describe "#piece_at" do
      piece_at_cases = [
        { coordinate: Coordinate.new(0, 0), type: "rook", color: "white" },
        { coordinate: Coordinate.new(2, 0), type: "bishop", color: "white" },
        { coordinate: Coordinate.new(3, 0), type: "queen", color: "white" },
        { coordinate: Coordinate.new(4, 0), type: "king", color: "white" },
        { coordinate: Coordinate.new(5, 0), type: "bishop", color: "white" },
        { coordinate: Coordinate.new(1, 0), type: "knight", color: "white" },
        { coordinate: Coordinate.new(6, 0), type: "knight", color: "white" },
        { coordinate: Coordinate.new(7, 0), type: "rook", color: "white" },
        { coordinate: Coordinate.new(0, 1), type: "pawn", color: "white" },
        { coordinate: Coordinate.new(1, 1), type: "pawn", color: "white" },
        { coordinate: Coordinate.new(2, 1), type: "pawn", color: "white" },
        { coordinate: Coordinate.new(3, 1), type: "pawn", color: "white" },
        { coordinate: Coordinate.new(4, 1), type: "pawn", color: "white" },
        { coordinate: Coordinate.new(5, 1), type: "pawn", color: "white" },
        { coordinate: Coordinate.new(6, 1), type: "pawn", color: "white" },
        { coordinate: Coordinate.new(7, 1), type: "pawn", color: "white" },
        { coordinate: Coordinate.new(0, 7), type: "rook", color: "black" },
        { coordinate: Coordinate.new(1, 7), type: "knight", color: "black" },
        { coordinate: Coordinate.new(2, 7), type: "bishop", color: "black" },
        { coordinate: Coordinate.new(3, 7), type: "queen", color: "black" },
        { coordinate: Coordinate.new(4, 7), type: "king", color: "black" },
        { coordinate: Coordinate.new(5, 7), type: "bishop", color: "black" },
        { coordinate: Coordinate.new(6, 7), type: "knight", color: "black" },
        { coordinate: Coordinate.new(7, 7), type: "rook", color: "black" },
        { coordinate: Coordinate.new(0, 6), type: "pawn", color: "black" },
        { coordinate: Coordinate.new(1, 6), type: "pawn", color: "black" },
        { coordinate: Coordinate.new(2, 6), type: "pawn", color: "black" },
        { coordinate: Coordinate.new(3, 6), type: "pawn", color: "black" },
        { coordinate: Coordinate.new(4, 6), type: "pawn", color: "black" },
        { coordinate: Coordinate.new(5, 6), type: "pawn", color: "black" },
        { coordinate: Coordinate.new(6, 6), type: "pawn", color: "black" },
        { coordinate: Coordinate.new(7, 6), type: "pawn", color: "black" }
      ]

      nil_coordinates = []
      4.times do |count_y|
        8.times do |count_x|
          nil_coordinates.push(Coordinate.new(count_x, count_y + 2))
        end
      end

      piece_at_cases.each do |p_case|
        it "returns #{p_case[:color]} #{p_case[:type]} on #{p_case[:coordinate].value_array}" do
          piece = board.piece_at(p_case[:coordinate])
          expect(piece.type).to eq(p_case[:type])
          expect(piece.coordinate).to eq(p_case[:coordinate])
          expect(piece.color.name).to eq(p_case[:color])
        end
      end

      nil_coordinates.each do |coord|
        it "returns NilPiece on #{coord.value_array} with matching coordinate" do
          piece = board.piece_at(coord)
          expect(piece.is_a?(NilPiece)).to eq(true)
          expect(piece.coordinate).to eq(coord)
          expect(piece.color.is_a?(NilColor)).to eq(true)
        end
      end
    end

    describe "#add_piece" do
      let(:new_coord) { Coordinate.new(5, 3) }
      let(:old_coord) { Coordinate.new(5, 1) }
      let(:new_pawn) { Pawn.new(white, old_coord, board) }
      before { board.add_piece(new_pawn, new_coord) }

      it "adds piece to board.pieces" do
        expect(board.pieces.include?(new_pawn)).to eq (true)
      end

      it "changes square at piece coordinate" do
        expect(board.squares[new_coord.x_value][new_coord.y_value]).to eq(
          new_pawn
        )
      end

      it "changes piece.coordinate" do
        expect(new_pawn.coordinate).to eq(new_coord)
      end

      it "sets piece has_moved to true" do
        expect(new_pawn.has_moved).to eq(true)
      end
    end

    describe "#remove_piece" do
      let(:old_coord) { Coordinate.new(3, 6) }
      before { board.remove_piece(old_coord) }

      it "removes piece from board.pieces" do
        expect(
          board.pieces.any? { |piece|
            piece.coordinate.equal?(Coordinate.new(3, 6))
          }
        ).to eq (false)
      end

      it "changes square at piece coordinate" do
        expect(
          board.squares[old_coord.x_value][old_coord.y_value].is_a?(NilPiece)
        ).to eq(true)
      end

      it "NilPiece coordinate is correct" do
        expect(
          board.squares[old_coord.x_value][old_coord.y_value].coordinate
        ).to eq(Coordinate.new(3, 6))
      end
    end
  end

  board_cases = [
    ChessTestCase.new(
      description: "When the black bishop can reach the white king",
      move_arrays: [
        [white, Coordinate.new(3, 1), Coordinate.new(3, 3)],
        [black, Coordinate.new(4, 6), Coordinate.new(4, 4)],
        [white, Coordinate.new(4, 1), Coordinate.new(4, 3)],
        [black, Coordinate.new(5, 7), Coordinate.new(1, 3)]
      ],
      in_check: white
    ),
    ChessTestCase.new(
      description: "When black get\'s scholar\'s mated",
      move_arrays: [
        [white, Coordinate.new(4, 1), Coordinate.new(4, 3)],
        [black, Coordinate.new(4, 6), Coordinate.new(4, 4)],
        [white, Coordinate.new(5, 0), Coordinate.new(2, 3)],
        [black, Coordinate.new(1, 7), Coordinate.new(2, 5)],
        [white, Coordinate.new(3, 0), Coordinate.new(7, 4)],
        [black, Coordinate.new(6, 7), Coordinate.new(5, 5)],
        [white, Coordinate.new(7, 4), Coordinate.new(5, 6)]
      ],
      in_check: black,
      checkmate: black
    )
  ]

  board_cases.each do |b_case|
    context "#{b_case.description}" do
      before do
        b_case.move_arrays.each do |move_array|
          move = Move.new(move_array[0], move_array[1], move_array[2], board)
          board.resolve(move)
        end
        allow(input).to receive(:win)
      end

      it " " do
        output = BoardOutput.new
        output.display_board(board, white, true)
      end

      describe "#in_check?" do
        expected_white = true if b_case.in_check == white
        expected_white = false if b_case.in_check != white

        it "returns #{expected_white} for white" do
          expect(board.in_check?(white)).to eq(expected_white)
        end

        expected_black = true if b_case.in_check == black
        expected_black = false if b_case.in_check != black

        it "returns #{expected_black} for black" do
          expect(board.in_check?(black)).to eq(expected_black)
        end
      end

      describe "#stalemate?" do
        it "returns #{b_case.stalemate}" do
          expect(board.stalemate?(colors)).to eq(b_case.stalemate)
        end
      end

      describe "#checkmate?" do
        expected_white = true if b_case.checkmate == white
        expected_white = false if b_case.checkmate != white

        it "returns #{expected_white} for white" do
          expect(board.checkmate?(white)).to eq(expected_white)
        end

        expected_black = true if b_case.checkmate == black
        expected_black = false if b_case.checkmate != black

        it "returns #{expected_black} for black" do
          expect(board.checkmate?(black)).to eq(expected_black)
        end
      end

      describe "#insufficient_material?" do
        it "returns #{b_case.insufficient_material}" do
          expect(board.insufficient_material?).to eq(
            b_case.insufficient_material
          )
        end
      end
    end
  end
end
