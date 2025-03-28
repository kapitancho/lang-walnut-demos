module demo-2d:

EmptySquare = :[];
EmptySquare ==> String :: '.';

Color = :[White, Black];
Piece = :[Pawn, Knight, Bishop, Rook, Queen, King];
Piece ==> String :: ?whenValueOf($) is {
    Piece.Pawn: 'p',
    Piece.Knight: 'n',
    Piece.Bishop: 'b',
    Piece.Rook: 'r',
    Piece.Queen: 'q',
    Piece.King: 'k'
};
ChessPiece = $[~Color, ~Piece];
ChessPiece ==> String :: ?whenValueOf($color) is {
    Color.White: $piece->asString->toUpperCase,
    Color.Black: $piece->asString
};
ChessSquare = $[piece: Mutable<ChessPiece|EmptySquare>];
ChessSquare(ChessPiece|EmptySquare) :: [piece: mutable{ChessPiece|EmptySquare, #}];
ChessSquare ==> String :: $piece->value->asString;
ChessSquare->SET_PIECE(^ChessPiece|EmptySquare => ChessSquare) :: {
    $piece->SET(#);
    $
};

ChessBoardRow = Array<ChessSquare, 8..8>;
ChessBoardRow ==> String :: [
    '|',
    $->map(^ChessSquare => String :: #->asString)->combineAsString(''),
    '|'
]->combineAsString('');

ChessBoard = $[squares: Array<ChessBoardRow, 8..8>];
ChessBoard() :: [
    squares: 1->upTo(8)->map(^Integer => Array<ChessSquare, 8..8> ::
        1->upTo(8)->map(^Integer => ChessSquare :: ChessSquare(EmptySquare()))
    )
];
ChessBoard ==> String :: [
    '/--------\\',
    $squares->map(^ChessBoardRow => String :: #->asString)->reverse->combineAsString('\n'),
    '\\--------/'
]->combineAsString('\n');

ChessBoard->setInitialPosition(=> ChessBoard) :: {
    $squares.1->map(^ChessSquare => ChessSquare :: #->SET_PIECE(ChessPiece[Color.White, Piece.Pawn]));
    $squares.6->map(^ChessSquare => ChessSquare :: #->SET_PIECE(ChessPiece[Color.Black, Piece.Pawn]));
    whiteRow = $squares.0;
    blackRow = $squares.7;
    whiteRow.0->SET_PIECE(ChessPiece[Color.White, Piece.Rook]);
    whiteRow.7->SET_PIECE(ChessPiece[Color.White, Piece.Rook]);
    blackRow.0->SET_PIECE(ChessPiece[Color.Black, Piece.Rook]);
    blackRow.7->SET_PIECE(ChessPiece[Color.Black, Piece.Rook]);
    whiteRow.1->SET_PIECE(ChessPiece[Color.White, Piece.Knight]);
    whiteRow.6->SET_PIECE(ChessPiece[Color.White, Piece.Knight]);
    blackRow.1->SET_PIECE(ChessPiece[Color.Black, Piece.Knight]);
    blackRow.6->SET_PIECE(ChessPiece[Color.Black, Piece.Knight]);
    whiteRow.2->SET_PIECE(ChessPiece[Color.White, Piece.Bishop]);
    whiteRow.5->SET_PIECE(ChessPiece[Color.White, Piece.Bishop]);
    blackRow.2->SET_PIECE(ChessPiece[Color.Black, Piece.Bishop]);
    blackRow.5->SET_PIECE(ChessPiece[Color.Black, Piece.Bishop]);
    whiteRow.3->SET_PIECE(ChessPiece[Color.White, Piece.Queen]);
    blackRow.3->SET_PIECE(ChessPiece[Color.Black, Piece.Queen]);
    whiteRow.4->SET_PIECE(ChessPiece[Color.White, Piece.King]);
    blackRow.4->SET_PIECE(ChessPiece[Color.Black, Piece.King]);

    $
};

myFn = ^Array<String> :: {
    chessBoard = ChessBoard();
    [
        chessBoard: chessBoard->asString,
        initialPosition: chessBoard->setInitialPosition->asString->OUT_HTML,
        end: 'end'
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};