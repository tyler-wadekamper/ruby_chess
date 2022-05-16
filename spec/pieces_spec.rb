require './lib/chess_pieces.rb'
require './spec/legal_moves_tester.rb'

describe ChessPiece do
  white = WhiteColor.new
  black = BlackColor.new
  let(:board) { double('ChessBoard') }

  describe '#legal_regular_moves' do
    legal_moves_cases =
      [{ subject: ['Pawn', white, Coordinate.new(5, 1)],
         supporting: [],
         expected: [[5, 2], [5, 3]],
         in_check: [] },
       { subject: ['Pawn', white, Coordinate.new(6, 5)],
         supporting: [],
         expected: [[6, 6]],
         in_check: [] },
       { subject: ['Pawn', white, Coordinate.new(0, 6)],
         supporting: [],
         expected: [[0, 7]],
         in_check: [] },
       { subject: ['Pawn', black, Coordinate.new(3, 6)],
         supporting: [],
         expected: [[3, 5], [3, 4]],
         in_check: [] },
       { subject: ['Pawn', black, Coordinate.new(0, 1)],
         supporting: [],
         expected: [[0, 0]],
         in_check: [] },
       { subject: ['Pawn', black, Coordinate.new(6, 3)],
         supporting: [['Rook', white, Coordinate.new(6, 2)]],
         expected: [],
         in_check: [] },
       { subject: ['Pawn', white, Coordinate.new(5, 2)],
         supporting: [['Pawn', black, Coordinate.new(5, 3)],
                      ['Bishop', black, Coordinate.new(6, 3)]],
         expected: [[6, 3]],
         in_check: [] },
       { subject: ['Pawn', black, Coordinate.new(2, 5)],
         supporting: [['Queen', black, Coordinate.new(2, 4)],
                      ['Knight', white, Coordinate.new(3, 4)]],
         expected: [[3, 4]],
         in_check: [] },
       { subject: ['Pawn', black, Coordinate.new(1, 6)],
         supporting: [['King', white, Coordinate.new(0, 5)],
                      ['Pawn', white, Coordinate.new(2, 5)]],
         expected: [[0, 5], [1, 5], [1, 4], [2, 5]],
         in_check: [] },
       { subject: ['Pawn', white, Coordinate.new(5, 4)],
         supporting: [['Rook', white, Coordinate.new(4, 5)],
                      ['Knight', black, Coordinate.new(6, 5)]],
         expected: [[5, 5], [6, 5]],
         in_check: [] },
       { subject: ['Pawn', black, Coordinate.new(5, 6)],
         supporting: [['Rook', black, Coordinate.new(4, 5)],
                      ['Queen', black, Coordinate.new(5, 5)],
                      ['Pawn', black, Coordinate.new(6, 5)]],
         expected: [],
         in_check: [] },
       { subject: ['Pawn', white, Coordinate.new(3, 1)],
         supporting: [],
         expected: [],
         in_check: [[3, 2], [3, 3]] },
       { subject: ['King', white, Coordinate.new(2, 6)],
         supporting: [],
         expected: [[1, 6], [1, 7], [2, 7], [3, 7],
                    [3, 6], [3, 5], [2, 5], [1, 5]],
         in_check: [] },
       { subject: ['King', black, Coordinate.new(1, 5)],
         supporting: [['Pawn', black, Coordinate.new(1, 4)],
                      ['Pawn', white, Coordinate.new(2, 5)],
                      ['Bishop', white, Coordinate.new(7, 0)],
                      ['Rook', white, Coordinate.new(0, 6)]],
         expected: [[0, 6], [2, 4]],
         in_check: [[0, 5], [1, 6], [2, 6], [2, 5], [0, 4]] },
       { subject: ['King', white, Coordinate.new(7, 4)],
         supporting: [['Queen', black, Coordinate.new(6, 4)],
                      ['Rook', black, Coordinate.new(6, 7)]],
         expected: [],
         in_check: [[6, 4], [6, 5], [7, 5], [7, 3], [6, 3], [6, 4]] },
       { subject: ['Queen', white, Coordinate.new(2, 2)],
         supporting: [['Rook', black, Coordinate.new(4, 4)],
                      ['Knight', black, Coordinate.new(5, 5)]],
         expected: [[1, 2], [0, 2], [1, 3], [0, 4], [2, 3], [2, 4], [2, 5],
                    [2, 6], [2, 7], [3, 3], [4, 4], [3, 2], [4, 2], [5, 2],
                    [6, 2], [7, 2], [3, 1], [4, 0], [2, 1], [2, 0], [1, 1],
                    [0, 0]],
         in_check: [] },
       { subject: ['Queen', black, Coordinate.new(0, 7)],
         supporting: [['Pawn', black, Coordinate.new(0, 1)]],
         expected: [[1, 7], [2, 7], [3, 7], [4, 7], [5, 7], [6, 7], [7, 7],
                    [1, 6], [2, 5], [3, 4], [4, 3], [5, 2], [6, 1], [7, 0],
                    [0, 6], [0, 5], [0, 4], [0, 3], [0, 2]],
         in_check: [] },
       { subject: ['Bishop', black, Coordinate.new(1, 2)],
         supporting: [['Pawn', black, Coordinate.new(3, 0)],
                      ['Pawn', white, Coordinate.new(4, 5)],
                      ['Pawn', white, Coordinate.new(5, 6)],],
         expected: [[0, 3], [2, 3], [3, 4], [4, 5], [2, 1], [0, 1]],
         in_check: [] },
       { subject: ['Knight', white, Coordinate.new(5, 5)],
         supporting: [['Pawn', black, Coordinate.new(7, 6)],
                      ['Pawn', white, Coordinate.new(7, 4)]],
         expected: [[3, 6], [4, 7], [6, 7], [7, 6], [6, 3], [4, 3], [3, 4]],
         in_check: [] },
       { subject: ['Rook', black, Coordinate.new(6, 1)],
         supporting: [['Pawn', black, Coordinate.new(4, 1)],
                      ['Pawn', white, Coordinate.new(6, 7)]],
         expected: [[5, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7], [7, 1], [6, 0]],
         in_check: [] },
        ]

    legal_moves_cases.each do |lm_case|
      context supporting_context(lm_case[:supporting]).to_s do
        before { allow_supporting(board, lm_case[:supporting]) }

        context check_context(lm_case[:in_check], lm_case[:subject][2]).to_s do
          before { allow_check(board, lm_case[:subject][2], lm_case[:in_check]) }

          subject(:subject_piece) do
            Object.const_get(lm_case[:subject][0]).new(lm_case[:subject][1], lm_case[:subject][2], board)
          end

          context to_string(lm_case[:subject][1].name, lm_case[:subject][0].downcase, lm_case[:subject][2]).to_s do
            move_array = expected_moves(lm_case[:subject][2], lm_case[:expected])

            it it_string(move_array).to_s do
              execute_it(subject_piece, move_array)
            end
          end
        end
      end
    end
  end
end