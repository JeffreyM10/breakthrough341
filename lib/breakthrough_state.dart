enum Piece {
  empty(' '),
  white('W'),
  black('B');

  final String str;

  const Piece(this.str);

  @override
  String toString() => str;
}

class BreakthroughState {
  //var board = List.generate(8, (size) => size * size, growable: false);
  List<Object> board = List<Object>.filled(64, Null);
  int rows = 8;
  int cols = 8;
  //row = pos/cols
  //col = pos % cols
  //pos = r * cols + c
  int wPiece = 0;
  int bPiece = 0;

  BreakthroughState(){
    //generate black pieces
    int r = 6;
    int c = 0;
    while(bPiece < 16){
      int pos = r * cols + c;
      board[pos] = Piece.black;
      ++c;
      if(c > 7){
        //c = 8, end of board
        c = 0;
        ++r;
      }
      ++bPiece;
    }

    //generate white pieces
    r = 0;
    c = 0;
    while(wPiece < 16){
      int pos = r * cols + c;
      board[pos] = Piece.white;
      ++c;
      if(c > 7){
        //c = 8, end of board
        c = 0;
        ++r;
      }
      ++wPiece;
    }
  }

  int getRow(int pos) {
      return pos ~/ cols;
    }

  int getCol(int pos){
      return pos%cols;
  }

  //move method(row, col, piece)
  void move(int row, int col){
    if(isValidMove() == true) {
     
    }
  }

  int getPos(int row, int col){
    return (row * cols + col);
  }

  bool isValidMove(int origin, int target, bool isWhite){
    //assemble list of valid moves
    List<int> validMoves = List<int>.empty();
    int oRow = getRow(origin);
    int oCol = getCol(origin);
    if(isWhite){
      //piece is moving 'up'

      //diag left (+1 row, -1 col)
      if(oCol != 0){
        //if == 0, can't move diag left
        int newMove = getPos(oRow + 1, oCol - 1);
        if(board[newMove] != Piece.white){
          //not occupied by different piece of same team.
          validMoves.add(newMove);
        }
      }
      //forward, no check for ANY piece
      int newMove = getPos(oRow + 1, oCol);
      if(board[newMove] == Piece.empty){
        validMoves.add(newMove);
      }

      //diag right (+1 row, +1 col)
      if(oCol != 7){
        //if == 7, can't move diag right
        int newMove = getPos(oRow + 1, oCol + 1);
        if(board[newMove] != Piece.white){
          //not occupied by different piece of same team.
          validMoves.add(newMove);
        }
      }     
    }

    if(!isWhite){
      //piece is moving 'down'

      //diag left (-1 row, -1 col)
      if(oCol != 0){
        //if == 0, can't move diag left
        int newMove = getPos(oRow - 1, oCol - 1);
        if(board[newMove] != Piece.black){
          //not occupied by different piece of same team.
          validMoves.add(newMove);
        }
      }
      //forward, check if ANY piece there
      int newMove = getPos(oRow - 1, oCol);
      if(board[newMove] == Piece.empty){
        validMoves.add(newMove);
      }

      //diag right (-1 row, +1 col)
      if(oCol != 7){
        //if == 7, can't move diag right
        int newMove = getPos(oRow - 1, oCol + 1);
        if(board[newMove] != Piece.black){
          //not occupied by different piece of same team.
          validMoves.add(newMove);
        }
      }
    }

    //validMoves found, check if target move is one of them.
    return validMoves.contains(target);
  }
}