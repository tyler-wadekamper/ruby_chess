require './lib/chess_pieces.rb'

def move_coord_array(from_coord, to_coord_array)
  result_array = []
  to_coord_array.each do |to_coord|
    result_array.push([from_coord, to_coord])
  end
  result_array
end

legal_moves_cases = [{subject: , supporting: , expected: , in_check: }]

describe '#legal_regular_moves' do
  lm_tester = LegalMovesTester.new
  legal_moves_cases.each do |lm_case|
    lm_tester.test(lm_case[:subject], lm_case[:supporting],
                   lm_case[:expected], lm_case[:in_check])
  end
end

describe Pawn do
  white = WhiteColor.new
  black = BlackColor.new
  let(:board) { double('ChessBoard') }
  before { allow(board).to receive(:mock_result).and_return(board) }

  describe '#legal_regular_moves' do
    context 'when move does not put self in check' do
      before { allow(board).to receive(:in_check?).and_return(false) }

      context 'when the board is empty' do
        before { allow(board).to receive(:piece_at).and_return(NilPiece.new) }

        cases = [{ color: white, square: 'f2', x: 5, y: 1, to_coords: [[5, 2], [5, 3]] },
                { color: white, square: 'g6', x: 6, y: 5, to_coords: [[6, 6]] },
                { color: white, square: 'a7', x: 0, y: 6, to_coords: [[0, 7]] },
                { color: black, square: 'd7', x: 3, y: 6, to_coords: [[3, 5], [3, 4]] },
                { color: black, square: 'a2', x: 0, y: 1, to_coords: [[0, 0]] }]

        cases.each do |t_case|
          color = t_case[:color]
          square = t_case[:square]
          x = t_case[:x]
          y = t_case[:y]
          to_coords = t_case[:to_coords]

          context "with only a #{color.name} pawn on #{square}" do
            subject(:pawn) { described_class.new(color, Coordinate.new(x, y), board) }
            let(:expected_moves) { move_coord_array([x, y], to_coords) }

            it "returns the moves #{move_coord_array([x, y], to_coords)}" do
              pawn_moves = pawn.legal_regular_moves

              move_values = pawn_moves.map(&:coordinates_array)
              expect(move_values).to eq(expected_moves)
            end
          end
        end
      end

      context 'when blocked forward' do
        context 'and can attack left or right' do
          before do
            allow(board).to receive(:piece_at)
              .and_return(attackable_l, attackable_l, blocking, attackable_r, attackable_r)
          end

          context 'a black pawn on e4' do
            let(:blocking) { Pawn.new(white, Coordinate.new(4, 2), board) }
            let(:attackable_l) { Pawn.new(white, Coordinate.new(5, 2), board) }
            let(:attackable_r) { Pawn.new(white, Coordinate.new(3, 2), board) }

            subject(:pawn) { described_class.new(black, Coordinate.new(4, 3), board) }

            to_coords = [[3, 2], [5, 2]]
            let(:expected_moves) { move_coord_array([4, 3], to_coords) }

            it "returns the moves #{move_coord_array([4, 3], to_coords)}" do
              pawn_moves = pawn.legal_regular_moves

              move_values = pawn_moves.map(&:coordinates_array)
              expect(move_values).to eq(expected_moves)
            end
          end

          context 'a white pawn on b2' do
            let(:blocking) { Pawn.new(white, Coordinate.new(1, 2), board) }
            let(:attackable_l) { Pawn.new(black, Coordinate.new(0, 2), board) }
            let(:attackable_r) { Pawn.new(black, Coordinate.new(2, 2), board) }

            subject(:pawn) { described_class.new(white, Coordinate.new(1, 1), board) }

            to_coords = [[0, 2], [2, 2]]
            let(:expected_moves) { move_coord_array([1, 1], to_coords) }

            it "returns the moves #{move_coord_array([1, 1], to_coords)}" do
              pawn_moves = pawn.legal_regular_moves

              move_values = pawn_moves.map(&:coordinates_array)
              expect(move_values).to eq(expected_moves)
            end
          end
        end

        context 'and attacking squares empty' do
          before do
            allow(board).to receive(:piece_at)
            .and_return(nil_attack, nil_attack, blocking, nil_attack, nil_attack) }
          end
          let(:blocking) { Pawn.new(black, Coordinate.new(1, 2), board) }
          let(:nil_attack) { NilPiece.new }

          context 'a black pawn on c7' do
            subject(:pawn) { described_class.new(black, Coordinate.new(1, 1), board) }

            it 'returns an empty array' do

            end
          end
        end

        context 'and attacking squares blocked by own color' do
          before { allow(board).to receive(:piece_at).with().and_return() }

          context 'a black pawn on d7' do
            it 'returns the correct moves' do
              
            end
          end
        end
      end

      # end

      # context 'when not blocked forward' do
      #   before { allow(board).to receive(:piece_at).with().and_return() }
        
      #   context 'and can attack left or right' do
      #     before { allow(board).to receive(:piece_at).with().and_return() }

      #     context 'a white pawn on c7' do
      #       it 'returns the correct moves' do
              
      #       end
      #     end
      #   end

      #   context 'and can attack right' do
      #     before { allow(board).to receive(:piece_at).with().and_return() }

      #     context 'a black pawn on h2' do
      #       it 'returns the correct moves' do
              
      #       end
      #     end
      #   end

      #   context 'and can attack left' do
      #     before { allow(board).to receive(:piece_at).with().and_return() }

      #     context 'a white pawn on g5' do
      #       it 'returns the correct moves' do
              
      #       end
      #     end
      #   end
      # end
    end

    # context 'when move puts self in check' do
    #   before { allow(board).to receive(:in_check?).and_return(true) }
    # end
  end
end