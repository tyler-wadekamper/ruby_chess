require "./lib/chess_board.rb"
require "./lib/chess_input.rb"
require "./lib/chess_pieces.rb"
require_relative "ChessTestCase"

describe ChessBoard do
  let(:input) { double("Input") }
  let(:manager) { double("Manager") }
  white = WhiteColor.new
  black = BlackColor.new
  colors = [black, white]
  before do
    allow(manager).to receive(:input).and_return(input)
    allow(manager).to receive(:colors).and_return(colors)
  end
  let(:initial_board) { described_class.new(manager) }

  context "with initial board setup" do
    describe "#piece_at" do
      piece_at_cases = [
        ChessTestCase.new(
          coordinate: Coordinate.new(0, 0),
          type: "rook",
          color: "white"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(2, 0),
          type: "bishop",
          color: "white"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(3, 0),
          type: "queen",
          color: "white"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(4, 0),
          type: "king",
          color: "white"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(5, 0),
          type: "bishop",
          color: "white"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(1, 0),
          type: "knight",
          color: "white"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(6, 0),
          type: "knight",
          color: "white"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(7, 0),
          type: "rook",
          color: "white"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(0, 1),
          type: "pawn",
          color: "white"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(1, 1),
          type: "pawn",
          color: "white"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(2, 1),
          type: "pawn",
          color: "white"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(3, 1),
          type: "pawn",
          color: "white"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(4, 1),
          type: "pawn",
          color: "white"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(5, 1),
          type: "pawn",
          color: "white"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(6, 1),
          type: "pawn",
          color: "white"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(7, 1),
          type: "pawn",
          color: "white"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(0, 7),
          type: "rook",
          color: "black"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(1, 7),
          type: "knight",
          color: "black"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(2, 7),
          type: "bishop",
          color: "black"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(3, 7),
          type: "queen",
          color: "black"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(4, 7),
          type: "king",
          color: "black"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(5, 7),
          type: "bishop",
          color: "black"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(6, 7),
          type: "knight",
          color: "black"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(7, 7),
          type: "rook",
          color: "black"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(0, 6),
          type: "pawn",
          color: "black"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(1, 6),
          type: "pawn",
          color: "black"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(2, 6),
          type: "pawn",
          color: "black"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(3, 6),
          type: "pawn",
          color: "black"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(4, 6),
          type: "pawn",
          color: "black"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(5, 6),
          type: "pawn",
          color: "black"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(6, 6),
          type: "pawn",
          color: "black"
        ),
        ChessTestCase.new(
          coordinate: Coordinate.new(7, 6),
          type: "pawn",
          color: "black"
        )
      ]

      nil_coordinates = []
      4.times do |count_y|
        8.times do |count_x|
          nil_coordinates.push(Coordinate.new(count_x, count_y + 2))
        end
      end

      piece_at_cases.each do |p_case|
        it "returns #{p_case.color} #{p_case.type} on #{p_case.coordinate.value_array}" do
          piece = initial_board.piece_at(p_case.coordinate)
          expect(piece.type).to eq(p_case.type)
          expect(piece.coordinate).to eq(p_case.coordinate)
          expect(piece.color.name).to eq(p_case.color)
          expect(piece.has_moved).to eq(false)
        end
      end

      nil_coordinates.each do |coord|
        it "returns NilPiece on #{coord.value_array} with matching coordinate" do
          piece = initial_board.piece_at(coord)
          expect(piece.is_a?(NilPiece)).to eq(true)
          expect(piece.coordinate).to eq(coord)
          expect(piece.color.is_a?(NilColor)).to eq(true)
        end
      end
    end

    describe "#add_piece" do
      let(:new_coord) { Coordinate.new(5, 3) }
      let(:old_coord) { Coordinate.new(5, 1) }

      add_cases = [
        ChessTestCase.new(
          description: "When adding a white pawn to [5, 3]",
          new_coord: Coordinate.new(5, 3),
          old_coord: Coordinate.new(5, 1),
          type: "Pawn",
          color: white,
          previous_has_moved: false,
          current_has_moved: false,
          set_has_moved: true
        ),
        ChessTestCase.new(
          description: "When adding a black queen to [2, 4]",
          new_coord: Coordinate.new(2, 4),
          old_coord: Coordinate.new(4, 2),
          type: "Queen",
          color: black,
          previous_has_moved: false,
          current_has_moved: true,
          set_has_moved: true
        ),
        ChessTestCase.new(
          description: "When adding a white bishop to [7, 5]",
          new_coord: Coordinate.new(7, 5),
          old_coord: Coordinate.new(5, 3),
          type: "Bishop",
          color: white,
          previous_has_moved: true,
          current_has_moved: false,
          set_has_moved: true
        ),
        ChessTestCase.new(
          description: "When adding a white bishop to [7, 5]",
          new_coord: Coordinate.new(7, 5),
          old_coord: Coordinate.new(5, 3),
          type: "Bishop",
          color: white,
          previous_has_moved: true,
          current_has_moved: true,
          set_has_moved: true
        ),
        ChessTestCase.new(
          description: "When adding a black bishop to [5, 3]",
          new_coord: Coordinate.new(5, 3),
          old_coord: Coordinate.new(5, 1),
          type: "Bishop",
          color: black,
          previous_has_moved: false,
          current_has_moved: false,
          set_has_moved: false
        ),
        ChessTestCase.new(
          description: "When adding a black rook to [2, 4]",
          new_coord: Coordinate.new(2, 4),
          old_coord: Coordinate.new(4, 2),
          type: "Rook",
          color: black,
          previous_has_moved: false,
          current_has_moved: true,
          set_has_moved: false
        ),
        ChessTestCase.new(
          description: "When adding a white queen to [7, 5]",
          new_coord: Coordinate.new(7, 5),
          old_coord: Coordinate.new(5, 3),
          type: "Queen",
          color: white,
          previous_has_moved: true,
          current_has_moved: false,
          set_has_moved: false
        ),
        ChessTestCase.new(
          description: "When adding a black knight to [7, 5]",
          new_coord: Coordinate.new(7, 5),
          old_coord: Coordinate.new(5, 3),
          type: "Knight",
          color: black,
          previous_has_moved: true,
          current_has_moved: true,
          set_has_moved: false
        )
      ]

      add_cases.each do |a_case|
        context "#{a_case.description}" do
          let(:new_piece) do
            Object.const_get(a_case.type).new(
              a_case.color,
              a_case.old_coord,
              initial_board,
              a_case.current_has_moved
            )
          end

          before do
            new_piece.previous_has_moved = a_case.previous_has_moved
            initial_board.add_piece(new_piece, a_case.new_coord)
          end

          it " " do
            output = BoardOutput.new
            output.display_board(initial_board, white, true)
          end

          it "adds piece to board.pieces" do
            expect(initial_board.pieces.include?(new_piece)).to eq (true)
          end

          it "changes square at piece coordinate" do
            expect(
              initial_board.squares[a_case.new_coord.x_value][
                a_case.new_coord.y_value
              ]
            ).to eq(new_piece)
          end

          it "changes piece.coordinate to #{a_case.new_coord.value_array}" do
            expect(new_piece.coordinate).to eq(a_case.new_coord)
          end

          it "changes piece.previous_coordinate to #{a_case.old_coord.value_array}" do
            expect(new_piece.previous_coordinate).to eq(a_case.old_coord)
          end

          it "sets piece has_moved and previous_has_moved to the correct values" do
            if a_case.set_has_moved == true
              expect(new_piece.moved?).to eq(true)
              expect(new_piece.previous_has_moved).to eq(
                a_case.current_has_moved
              )
            end

            if a_case.set_has_moved == false
              expect(new_piece.moved?).to eq(a_case.current_has_moved)
              expect(new_piece.previous_has_moved).to eq(
                a_case.previous_has_moved
              )
            end
          end
        end
      end
    end

    describe "#remove_piece" do
      remove_cases = [
        ChessTestCase.new(
          description: "When removing a piece from [3, 6]",
          old_coord: Coordinate.new(3, 6)
        ),
        ChessTestCase.new(
          description: "When removing a piece from [2, 7]",
          old_coord: Coordinate.new(2, 7)
        ),
        ChessTestCase.new(
          description: "When removing a piece from [6, 0]",
          old_coord: Coordinate.new(6, 0)
        ),
        ChessTestCase.new(
          description: "When removing a piece from [0, 0]",
          old_coord: Coordinate.new(0, 0)
        ),
        ChessTestCase.new(
          description: "When removing a piece from [7, 1]",
          old_coord: Coordinate.new(7, 1)
        )
      ]

      remove_cases.each do |r_case|
        context "#{r_case.description}" do
          let(:old_coord) { r_case.old_coord }

          before { initial_board.remove_piece(old_coord) }

          it " " do
            output = BoardOutput.new
            output.display_board(initial_board, white, true)
          end

          it "removes piece from board.pieces" do
            expect(
              initial_board.pieces.any? { |piece|
                piece.coordinate.equal?(old_coord)
              }
            ).to eq (false)
          end

          it "changes square at piece coordinate" do
            expect(
              initial_board.squares[old_coord.x_value][old_coord.y_value].is_a?(
                NilPiece
              )
            ).to eq(true)
          end

          it "NilPiece coordinate is correct" do
            expect(
              initial_board.squares[old_coord.x_value][
                old_coord.y_value
              ].coordinate
            ).to eq(old_coord)
          end
        end
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
      description: "When a piece is blocking check",
      move_arrays: [
        [white, Coordinate.new(3, 1), Coordinate.new(3, 3)],
        [black, Coordinate.new(3, 6), Coordinate.new(3, 4)],
        [white, Coordinate.new(4, 1), Coordinate.new(4, 3)],
        [black, Coordinate.new(3, 7), Coordinate.new(3, 6)],
        [white, Coordinate.new(5, 0), Coordinate.new(1, 4)]
      ]
    ),
    ChessTestCase.new(
      description: "When white uses scholar's mate",
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
    ),
    ChessTestCase.new(
      description: "When black can only block to avoid checkmate",
      move_arrays: [
        [white, Coordinate.new(2, 1), Coordinate.new(2, 3)],
        [black, Coordinate.new(3, 6), Coordinate.new(3, 4)],
        [white, Coordinate.new(3, 0), Coordinate.new(0, 3)]
      ],
      in_check: black
    ),
    ChessTestCase.new(
      description: "When white can only capture to avoid checkmate",
      move_arrays: [
        [white, Coordinate.new(5, 1), Coordinate.new(5, 3)],
        [black, Coordinate.new(4, 6), Coordinate.new(4, 4)],
        [white, Coordinate.new(6, 1), Coordinate.new(6, 3)],
        [black, Coordinate.new(5, 7), Coordinate.new(2, 4)],
        [white, Coordinate.new(6, 0), Coordinate.new(5, 2)],
        [black, Coordinate.new(3, 7), Coordinate.new(7, 3)]
      ],
      in_check: white
    ),
    ChessTestCase.new(
      description: "When two pieces threaten the king",
      move_arrays: [
        [white, Coordinate.new(4, 1), Coordinate.new(4, 3)],
        [black, Coordinate.new(4, 6), Coordinate.new(4, 4)],
        [white, Coordinate.new(3, 0), Coordinate.new(6, 3)],
        [black, Coordinate.new(3, 6), Coordinate.new(3, 4)],
        [white, Coordinate.new(7, 1), Coordinate.new(7, 3)],
        [black, Coordinate.new(1, 7), Coordinate.new(2, 5)],
        [white, Coordinate.new(7, 0), Coordinate.new(7, 2)],
        [black, Coordinate.new(3, 4), Coordinate.new(3, 3)],
        [white, Coordinate.new(7, 2), Coordinate.new(5, 2)],
        [black, Coordinate.new(4, 7), Coordinate.new(4, 6)],
        [white, Coordinate.new(5, 2), Coordinate.new(5, 4)],
        [black, Coordinate.new(4, 6), Coordinate.new(4, 5)],
        [white, Coordinate.new(5, 4), Coordinate.new(5, 5)]
      ],
      in_check: black
    ),
    ChessTestCase.new(
      description: "When white is not in check and cannot move",
      move_arrays: [
        [white, Coordinate.new(4, 1), Coordinate.new(4, 3)],
        [black, Coordinate.new(3, 6), Coordinate.new(3, 4)],
        [white, Coordinate.new(4, 3), Coordinate.new(3, 4)],
        [black, Coordinate.new(3, 7), Coordinate.new(3, 4)],
        [white, Coordinate.new(3, 0), Coordinate.new(6, 3)],
        [black, Coordinate.new(3, 4), Coordinate.new(6, 1)],
        [white, Coordinate.new(6, 3), Coordinate.new(6, 6)],
        [black, Coordinate.new(6, 1), Coordinate.new(7, 0)],
        [white, Coordinate.new(6, 6), Coordinate.new(6, 7)],
        [black, Coordinate.new(7, 0), Coordinate.new(6, 0)],
        [white, Coordinate.new(6, 7), Coordinate.new(7, 6)],
        [black, Coordinate.new(6, 0), Coordinate.new(7, 1)],
        [white, Coordinate.new(7, 6), Coordinate.new(7, 7)],
        [black, Coordinate.new(7, 1), Coordinate.new(5, 1)],
        [white, Coordinate.new(4, 0), Coordinate.new(3, 0)],
        [black, Coordinate.new(5, 1), Coordinate.new(6, 1)],
        [white, Coordinate.new(7, 7), Coordinate.new(7, 0)],
        [black, Coordinate.new(6, 1), Coordinate.new(7, 0)],
        [white, Coordinate.new(3, 0), Coordinate.new(4, 1)],
        [black, Coordinate.new(4, 1), Coordinate.new(3, 2)],
        [black, Coordinate.new(7, 0), Coordinate.new(2, 0)],
        [white, Coordinate.new(3, 2), Coordinate.new(4, 2)],
        [black, Coordinate.new(2, 0), Coordinate.new(1, 0)],
        [white, Coordinate.new(2, 1), Coordinate.new(2, 2)],
        [black, Coordinate.new(1, 0), Coordinate.new(0, 0)],
        [white, Coordinate.new(4, 2), Coordinate.new(4, 3)],
        [black, Coordinate.new(0, 0), Coordinate.new(0, 1)],
        [white, Coordinate.new(1, 1), Coordinate.new(1, 2)],
        [black, Coordinate.new(0, 1), Coordinate.new(3, 1)],
        [white, Coordinate.new(1, 2), Coordinate.new(1, 3)],
        [black, Coordinate.new(3, 1), Coordinate.new(2, 2)],
        [white, Coordinate.new(4, 3), Coordinate.new(5, 3)],
        [black, Coordinate.new(2, 2), Coordinate.new(1, 3)],
        [white, Coordinate.new(5, 0), Coordinate.new(2, 3)],
        [black, Coordinate.new(1, 3), Coordinate.new(2, 3)],
        [white, Coordinate.new(5, 3), Coordinate.new(4, 4)],
        [black, Coordinate.new(2, 3), Coordinate.new(3, 2)],
        [white, Coordinate.new(4, 4), Coordinate.new(5, 3)],
        [black, Coordinate.new(5, 6), Coordinate.new(5, 5)]
      ],
      stalemate: white
    ),
    ChessTestCase.new(
      description: "When only bishops, but opposite squares",
      move_arrays: [
        [white, Coordinate.new(4, 1), Coordinate.new(4, 3)],
        [black, Coordinate.new(3, 6), Coordinate.new(3, 4)],
        [white, Coordinate.new(4, 3), Coordinate.new(3, 4)],
        [black, Coordinate.new(3, 7), Coordinate.new(3, 4)],
        [white, Coordinate.new(3, 0), Coordinate.new(6, 3)],
        [black, Coordinate.new(3, 4), Coordinate.new(6, 1)],
        [white, Coordinate.new(6, 3), Coordinate.new(6, 6)],
        [black, Coordinate.new(6, 1), Coordinate.new(7, 0)],
        [white, Coordinate.new(6, 6), Coordinate.new(6, 7)],
        [black, Coordinate.new(7, 0), Coordinate.new(6, 0)],
        [white, Coordinate.new(6, 7), Coordinate.new(7, 6)],
        [black, Coordinate.new(6, 0), Coordinate.new(7, 1)],
        [white, Coordinate.new(7, 6), Coordinate.new(7, 7)],
        [black, Coordinate.new(7, 1), Coordinate.new(5, 1)],
        [white, Coordinate.new(4, 0), Coordinate.new(3, 0)],
        [black, Coordinate.new(5, 1), Coordinate.new(6, 1)],
        [white, Coordinate.new(7, 7), Coordinate.new(7, 0)],
        [black, Coordinate.new(6, 1), Coordinate.new(3, 4)],
        [white, Coordinate.new(7, 0), Coordinate.new(7, 1)],
        [black, Coordinate.new(3, 4), Coordinate.new(0, 1)],
        [white, Coordinate.new(7, 1), Coordinate.new(2, 6)],
        [black, Coordinate.new(0, 1), Coordinate.new(0, 0)],
        [white, Coordinate.new(2, 6), Coordinate.new(1, 7)],
        [black, Coordinate.new(0, 0), Coordinate.new(1, 1)],
        [white, Coordinate.new(3, 0), Coordinate.new(4, 1)],
        [black, Coordinate.new(5, 6), Coordinate.new(5, 4)],
        [white, Coordinate.new(1, 7), Coordinate.new(2, 7)],
        [black, Coordinate.new(4, 7), Coordinate.new(5, 6)],
        [white, Coordinate.new(2, 7), Coordinate.new(5, 4)],
        [black, Coordinate.new(5, 6), Coordinate.new(6, 6)],
        [white, Coordinate.new(5, 4), Coordinate.new(0, 4)],
        [black, Coordinate.new(1, 1), Coordinate.new(2, 1)],
        [white, Coordinate.new(4, 1), Coordinate.new(5, 2)],
        [black, Coordinate.new(2, 1), Coordinate.new(2, 0)],
        [white, Coordinate.new(0, 4), Coordinate.new(0, 6)],
        [black, Coordinate.new(2, 0), Coordinate.new(3, 1)],
        [white, Coordinate.new(0, 6), Coordinate.new(0, 7)],
        [black, Coordinate.new(6, 6), Coordinate.new(7, 6)],
        [white, Coordinate.new(5, 2), Coordinate.new(6, 2)],
        [black, Coordinate.new(7, 6), Coordinate.new(7, 7)],
        [white, Coordinate.new(0, 7), Coordinate.new(1, 6)],
        [black, Coordinate.new(3, 1), Coordinate.new(1, 3)],
        [white, Coordinate.new(1, 6), Coordinate.new(4, 6)],
        [black, Coordinate.new(7, 7), Coordinate.new(7, 6)],
        [white, Coordinate.new(4, 6), Coordinate.new(1, 3)],
        [black, Coordinate.new(5, 7), Coordinate.new(1, 3)],
        [white, Coordinate.new(1, 0), Coordinate.new(3, 1)],
        [black, Coordinate.new(1, 3), Coordinate.new(3, 1)]
      ],
      insufficient_material: false
    ),
    ChessTestCase.new(
      description: "When insufficient material with one bishop",
      move_arrays: [
        [white, Coordinate.new(4, 1), Coordinate.new(4, 3)],
        [black, Coordinate.new(3, 6), Coordinate.new(3, 4)],
        [white, Coordinate.new(4, 3), Coordinate.new(3, 4)],
        [black, Coordinate.new(3, 7), Coordinate.new(3, 4)],
        [white, Coordinate.new(3, 0), Coordinate.new(6, 3)],
        [black, Coordinate.new(3, 4), Coordinate.new(6, 1)],
        [white, Coordinate.new(6, 3), Coordinate.new(6, 6)],
        [black, Coordinate.new(6, 1), Coordinate.new(7, 0)],
        [white, Coordinate.new(6, 6), Coordinate.new(6, 7)],
        [black, Coordinate.new(7, 0), Coordinate.new(6, 0)],
        [white, Coordinate.new(6, 7), Coordinate.new(7, 6)],
        [black, Coordinate.new(6, 0), Coordinate.new(7, 1)],
        [white, Coordinate.new(7, 6), Coordinate.new(7, 7)],
        [black, Coordinate.new(7, 1), Coordinate.new(5, 1)],
        [white, Coordinate.new(4, 0), Coordinate.new(3, 0)],
        [black, Coordinate.new(5, 1), Coordinate.new(6, 1)],
        [white, Coordinate.new(7, 7), Coordinate.new(7, 0)],
        [black, Coordinate.new(6, 1), Coordinate.new(3, 4)],
        [white, Coordinate.new(7, 0), Coordinate.new(7, 1)],
        [black, Coordinate.new(3, 4), Coordinate.new(0, 1)],
        [white, Coordinate.new(7, 1), Coordinate.new(2, 6)],
        [black, Coordinate.new(0, 1), Coordinate.new(0, 0)],
        [white, Coordinate.new(2, 6), Coordinate.new(1, 7)],
        [black, Coordinate.new(0, 0), Coordinate.new(1, 1)],
        [white, Coordinate.new(3, 0), Coordinate.new(4, 1)],
        [black, Coordinate.new(5, 6), Coordinate.new(5, 4)],
        [white, Coordinate.new(1, 7), Coordinate.new(2, 7)],
        [black, Coordinate.new(4, 7), Coordinate.new(5, 6)],
        [white, Coordinate.new(2, 7), Coordinate.new(5, 4)],
        [black, Coordinate.new(5, 6), Coordinate.new(6, 6)],
        [white, Coordinate.new(5, 4), Coordinate.new(0, 4)],
        [black, Coordinate.new(1, 1), Coordinate.new(2, 1)],
        [white, Coordinate.new(4, 1), Coordinate.new(5, 2)],
        [black, Coordinate.new(2, 1), Coordinate.new(2, 0)],
        [white, Coordinate.new(0, 4), Coordinate.new(0, 6)],
        [black, Coordinate.new(2, 0), Coordinate.new(3, 1)],
        [white, Coordinate.new(0, 6), Coordinate.new(0, 7)],
        [black, Coordinate.new(6, 6), Coordinate.new(7, 6)],
        [white, Coordinate.new(5, 2), Coordinate.new(6, 2)],
        [black, Coordinate.new(7, 6), Coordinate.new(7, 7)],
        [white, Coordinate.new(0, 7), Coordinate.new(1, 6)],
        [black, Coordinate.new(3, 1), Coordinate.new(1, 3)],
        [white, Coordinate.new(1, 6), Coordinate.new(4, 6)],
        [black, Coordinate.new(7, 7), Coordinate.new(7, 6)],
        [white, Coordinate.new(4, 6), Coordinate.new(1, 3)],
        [black, Coordinate.new(5, 7), Coordinate.new(1, 3)],
        [white, Coordinate.new(1, 0), Coordinate.new(3, 1)],
        [black, Coordinate.new(1, 3), Coordinate.new(3, 1)],
        [white, Coordinate.new(6, 2), Coordinate.new(6, 3)],
        [black, Coordinate.new(3, 1), Coordinate.new(5, 3)],
        [white, Coordinate.new(6, 3), Coordinate.new(5, 3)]
      ],
      insufficient_material: true
    ),
    ChessTestCase.new(
      description: "When insufficient material with only kings",
      move_arrays: [
        [white, Coordinate.new(4, 1), Coordinate.new(4, 3)],
        [black, Coordinate.new(3, 6), Coordinate.new(3, 4)],
        [white, Coordinate.new(4, 3), Coordinate.new(3, 4)],
        [black, Coordinate.new(3, 7), Coordinate.new(3, 4)],
        [white, Coordinate.new(3, 0), Coordinate.new(6, 3)],
        [black, Coordinate.new(3, 4), Coordinate.new(6, 1)],
        [white, Coordinate.new(6, 3), Coordinate.new(6, 6)],
        [black, Coordinate.new(6, 1), Coordinate.new(7, 0)],
        [white, Coordinate.new(6, 6), Coordinate.new(6, 7)],
        [black, Coordinate.new(7, 0), Coordinate.new(6, 0)],
        [white, Coordinate.new(6, 7), Coordinate.new(7, 6)],
        [black, Coordinate.new(6, 0), Coordinate.new(7, 1)],
        [white, Coordinate.new(7, 6), Coordinate.new(7, 7)],
        [black, Coordinate.new(7, 1), Coordinate.new(5, 1)],
        [white, Coordinate.new(4, 0), Coordinate.new(3, 0)],
        [black, Coordinate.new(5, 1), Coordinate.new(6, 1)],
        [white, Coordinate.new(7, 7), Coordinate.new(7, 0)],
        [black, Coordinate.new(6, 1), Coordinate.new(3, 4)],
        [white, Coordinate.new(7, 0), Coordinate.new(7, 1)],
        [black, Coordinate.new(3, 4), Coordinate.new(0, 1)],
        [white, Coordinate.new(7, 1), Coordinate.new(2, 6)],
        [black, Coordinate.new(0, 1), Coordinate.new(0, 0)],
        [white, Coordinate.new(2, 6), Coordinate.new(1, 7)],
        [black, Coordinate.new(0, 0), Coordinate.new(1, 1)],
        [white, Coordinate.new(3, 0), Coordinate.new(4, 1)],
        [black, Coordinate.new(5, 6), Coordinate.new(5, 4)],
        [white, Coordinate.new(1, 7), Coordinate.new(2, 7)],
        [black, Coordinate.new(4, 7), Coordinate.new(5, 6)],
        [white, Coordinate.new(2, 7), Coordinate.new(5, 4)],
        [black, Coordinate.new(5, 6), Coordinate.new(6, 6)],
        [white, Coordinate.new(5, 4), Coordinate.new(0, 4)],
        [black, Coordinate.new(1, 1), Coordinate.new(2, 1)],
        [white, Coordinate.new(4, 1), Coordinate.new(5, 2)],
        [black, Coordinate.new(2, 1), Coordinate.new(2, 0)],
        [white, Coordinate.new(0, 4), Coordinate.new(0, 6)],
        [black, Coordinate.new(2, 0), Coordinate.new(3, 1)],
        [white, Coordinate.new(0, 6), Coordinate.new(0, 7)],
        [black, Coordinate.new(6, 6), Coordinate.new(7, 6)],
        [white, Coordinate.new(5, 2), Coordinate.new(6, 2)],
        [black, Coordinate.new(7, 6), Coordinate.new(7, 7)],
        [white, Coordinate.new(0, 7), Coordinate.new(1, 6)],
        [black, Coordinate.new(3, 1), Coordinate.new(1, 3)],
        [white, Coordinate.new(1, 6), Coordinate.new(4, 6)],
        [black, Coordinate.new(7, 7), Coordinate.new(7, 6)],
        [white, Coordinate.new(4, 6), Coordinate.new(1, 3)],
        [black, Coordinate.new(5, 7), Coordinate.new(1, 3)],
        [white, Coordinate.new(1, 0), Coordinate.new(3, 1)],
        [black, Coordinate.new(1, 3), Coordinate.new(3, 1)],
        [white, Coordinate.new(6, 2), Coordinate.new(6, 3)],
        [black, Coordinate.new(3, 1), Coordinate.new(5, 3)],
        [white, Coordinate.new(6, 3), Coordinate.new(5, 3)],
        [black, Coordinate.new(7, 6), Coordinate.new(6, 6)],
        [white, Coordinate.new(5, 0), Coordinate.new(2, 3)],
        [black, Coordinate.new(6, 6), Coordinate.new(5, 7)],
        [white, Coordinate.new(2, 3), Coordinate.new(5, 6)],
        [black, Coordinate.new(5, 7), Coordinate.new(5, 6)]
      ],
      insufficient_material: true
    ),
    ChessTestCase.new(
      description: "When insufficient material with only one knight",
      move_arrays: [
        [white, Coordinate.new(4, 1), Coordinate.new(4, 3)],
        [black, Coordinate.new(3, 6), Coordinate.new(3, 4)],
        [white, Coordinate.new(4, 3), Coordinate.new(3, 4)],
        [black, Coordinate.new(3, 7), Coordinate.new(3, 4)],
        [white, Coordinate.new(3, 0), Coordinate.new(6, 3)],
        [black, Coordinate.new(3, 4), Coordinate.new(6, 1)],
        [white, Coordinate.new(6, 3), Coordinate.new(6, 6)],
        [black, Coordinate.new(6, 1), Coordinate.new(7, 0)],
        [white, Coordinate.new(6, 6), Coordinate.new(6, 7)],
        [black, Coordinate.new(7, 0), Coordinate.new(6, 0)],
        [white, Coordinate.new(6, 7), Coordinate.new(7, 6)],
        [black, Coordinate.new(6, 0), Coordinate.new(7, 1)],
        [white, Coordinate.new(7, 6), Coordinate.new(7, 7)],
        [black, Coordinate.new(7, 1), Coordinate.new(5, 1)],
        [white, Coordinate.new(4, 0), Coordinate.new(3, 0)],
        [black, Coordinate.new(5, 1), Coordinate.new(6, 1)],
        [white, Coordinate.new(7, 7), Coordinate.new(7, 0)],
        [black, Coordinate.new(6, 1), Coordinate.new(3, 4)],
        [white, Coordinate.new(7, 0), Coordinate.new(7, 1)],
        [black, Coordinate.new(3, 4), Coordinate.new(0, 1)],
        [white, Coordinate.new(7, 1), Coordinate.new(2, 6)],
        [black, Coordinate.new(0, 1), Coordinate.new(0, 0)],
        [white, Coordinate.new(2, 6), Coordinate.new(1, 7)],
        [black, Coordinate.new(0, 0), Coordinate.new(1, 1)],
        [white, Coordinate.new(3, 0), Coordinate.new(4, 1)],
        [black, Coordinate.new(5, 6), Coordinate.new(5, 4)],
        [white, Coordinate.new(1, 7), Coordinate.new(2, 7)],
        [black, Coordinate.new(4, 7), Coordinate.new(5, 6)],
        [white, Coordinate.new(2, 7), Coordinate.new(5, 4)],
        [black, Coordinate.new(5, 6), Coordinate.new(6, 6)],
        [white, Coordinate.new(5, 4), Coordinate.new(0, 4)],
        [black, Coordinate.new(1, 1), Coordinate.new(2, 1)],
        [white, Coordinate.new(4, 1), Coordinate.new(5, 2)],
        [black, Coordinate.new(2, 1), Coordinate.new(2, 0)],
        [white, Coordinate.new(0, 4), Coordinate.new(0, 6)],
        [black, Coordinate.new(2, 0), Coordinate.new(3, 1)],
        [white, Coordinate.new(0, 6), Coordinate.new(0, 7)],
        [black, Coordinate.new(6, 6), Coordinate.new(7, 6)],
        [white, Coordinate.new(5, 2), Coordinate.new(6, 2)],
        [black, Coordinate.new(7, 6), Coordinate.new(7, 7)],
        [white, Coordinate.new(0, 7), Coordinate.new(1, 6)],
        [black, Coordinate.new(3, 1), Coordinate.new(1, 3)],
        [white, Coordinate.new(1, 6), Coordinate.new(4, 6)],
        [black, Coordinate.new(7, 7), Coordinate.new(7, 6)],
        [white, Coordinate.new(4, 6), Coordinate.new(1, 3)],
        [black, Coordinate.new(5, 7), Coordinate.new(1, 3)],
        [white, Coordinate.new(5, 0), Coordinate.new(2, 3)],
        [black, Coordinate.new(1, 3), Coordinate.new(0, 2)],
        [white, Coordinate.new(2, 3), Coordinate.new(6, 7)],
        [black, Coordinate.new(7, 6), Coordinate.new(6, 7)],
        [white, Coordinate.new(1, 0), Coordinate.new(0, 2)]
      ],
      insufficient_material: true
    ),
    ChessTestCase.new(
      description: "When insufficient material with same square bishops",
      move_arrays: [
        [white, Coordinate.new(4, 1), Coordinate.new(4, 3)],
        [black, Coordinate.new(3, 6), Coordinate.new(3, 4)],
        [white, Coordinate.new(4, 3), Coordinate.new(3, 4)],
        [black, Coordinate.new(3, 7), Coordinate.new(3, 4)],
        [white, Coordinate.new(3, 0), Coordinate.new(6, 3)],
        [black, Coordinate.new(3, 4), Coordinate.new(6, 1)],
        [white, Coordinate.new(6, 3), Coordinate.new(6, 6)],
        [black, Coordinate.new(6, 1), Coordinate.new(7, 0)],
        [white, Coordinate.new(6, 6), Coordinate.new(6, 7)],
        [black, Coordinate.new(7, 0), Coordinate.new(6, 0)],
        [white, Coordinate.new(6, 7), Coordinate.new(7, 6)],
        [black, Coordinate.new(6, 0), Coordinate.new(7, 1)],
        [white, Coordinate.new(7, 6), Coordinate.new(7, 7)],
        [black, Coordinate.new(7, 1), Coordinate.new(5, 1)],
        [white, Coordinate.new(4, 0), Coordinate.new(3, 0)],
        [black, Coordinate.new(5, 1), Coordinate.new(6, 1)],
        [white, Coordinate.new(7, 7), Coordinate.new(7, 0)],
        [black, Coordinate.new(6, 1), Coordinate.new(3, 4)],
        [white, Coordinate.new(7, 0), Coordinate.new(7, 1)],
        [black, Coordinate.new(3, 4), Coordinate.new(0, 1)],
        [white, Coordinate.new(7, 1), Coordinate.new(2, 6)],
        [black, Coordinate.new(0, 1), Coordinate.new(0, 0)],
        [white, Coordinate.new(2, 6), Coordinate.new(1, 7)],
        [black, Coordinate.new(0, 0), Coordinate.new(1, 1)],
        [white, Coordinate.new(3, 0), Coordinate.new(4, 1)],
        [black, Coordinate.new(5, 6), Coordinate.new(5, 4)],
        [white, Coordinate.new(1, 7), Coordinate.new(2, 7)],
        [black, Coordinate.new(4, 7), Coordinate.new(5, 6)],
        [white, Coordinate.new(2, 7), Coordinate.new(5, 4)],
        [black, Coordinate.new(5, 6), Coordinate.new(6, 6)],
        [white, Coordinate.new(5, 4), Coordinate.new(0, 4)],
        [black, Coordinate.new(1, 1), Coordinate.new(5, 5)],
        [white, Coordinate.new(4, 1), Coordinate.new(3, 2)],
        [black, Coordinate.new(5, 5), Coordinate.new(5, 0)],
        [white, Coordinate.new(3, 2), Coordinate.new(4, 2)],
        [black, Coordinate.new(5, 0), Coordinate.new(1, 4)],
        [white, Coordinate.new(4, 2), Coordinate.new(5, 2)],
        [black, Coordinate.new(1, 4), Coordinate.new(1, 1)],
        [white, Coordinate.new(5, 2), Coordinate.new(4, 1)],
        [black, Coordinate.new(1, 1), Coordinate.new(2, 1)],
        [white, Coordinate.new(4, 1), Coordinate.new(5, 2)],
        [black, Coordinate.new(2, 1), Coordinate.new(1, 2)],
        [white, Coordinate.new(0, 4), Coordinate.new(0, 6)],
        [black, Coordinate.new(1, 2), Coordinate.new(1, 0)],
        [white, Coordinate.new(0, 6), Coordinate.new(0, 7)],
        [black, Coordinate.new(6, 6), Coordinate.new(7, 6)],
        [white, Coordinate.new(5, 2), Coordinate.new(6, 2)],
        [black, Coordinate.new(7, 6), Coordinate.new(7, 7)],
        [white, Coordinate.new(0, 7), Coordinate.new(1, 6)],
        [black, Coordinate.new(1, 0), Coordinate.new(2, 1)],
        [white, Coordinate.new(1, 6), Coordinate.new(4, 6)],
        [black, Coordinate.new(2, 1), Coordinate.new(3, 1)],
        [white, Coordinate.new(4, 6), Coordinate.new(3, 5)],
        [black, Coordinate.new(3, 1), Coordinate.new(3, 5)],
        [white, Coordinate.new(2, 0), Coordinate.new(5, 3)],
        [black, Coordinate.new(3, 5), Coordinate.new(4, 4)],
        [white, Coordinate.new(5, 3), Coordinate.new(4, 4)]
      ],
      insufficient_material: true,
      in_check: black
    )
  ]

  board_cases.each do |b_case|
    context "#{b_case.description}" do
      let(:board) do
        move_list = []
        b_case.move_arrays.each do |move_array|
          move_list.push(
            Move.new(move_array[0], move_array[1], move_array[2], manager)
          )
        end
        ChessBoard.new(manager, move_list)
      end

      before do
        allow(input).to receive(:win)
        move_list = []
        b_case.move_arrays.each do |move_array|
          move_list.push(
            Move.new(move_array[0], move_array[1], move_array[2], manager)
          )
        end
        allow(manager).to receive(:move_list_copy).and_return(move_list)
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
        expected_white = true if b_case.stalemate == white
        expected_white = false if b_case.stalemate != white

        it "returns #{expected_white} when given white" do
          expect(board.stalemate?(white)).to eq(expected_white)
        end

        expected_black = true if b_case.stalemate == black
        expected_black = false if b_case.stalemate != black

        it "returns #{expected_black} when given black" do
          expect(board.stalemate?(black)).to eq(expected_black)
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
