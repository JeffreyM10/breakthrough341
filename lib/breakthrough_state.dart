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
  late List<Piece> board;
  int rows = 8;
  int cols = 8;
  //row = pos/cols
  //col = pos % cols
  //pos = r * cols + c
  int wPieces = 0;
  int bPieces = 0;
  late Piece currentPlayer, winner;


  BreakthroughState(){
    newGame();
  }

  void newGame(){
    //initalize key variables
    currentPlayer = Piece.white;
    winner = Piece.empty;
    board = List<Piece>.filled(64, Piece.empty);

    //generate black pieces
    int r = 6;
    int c = 0;
    while(bPieces < 16){
      int pos = r * cols + c;
      board[pos] = Piece.black;
      ++c;
      if(c > 7){
        //c = 8, end of board
        c = 0;
        ++r;
      }
      ++bPieces;
    }

    //generate white pieces
    r = 0;
    c = 0;
    while(wPieces < 16){
      int pos = r * cols + c;
      board[pos] = Piece.white;
      ++c;
      if(c > 7){
        //c = 8, end of board
        c = 0;
        ++r;
      }
      ++wPieces;
    }
  }
  
  int getRow(int pos) {
      return pos ~/ cols;
    }

  int getCol(int pos){
      return pos%cols;
  }

  Piece getWinner() => winner;

  ///move method(origin pos, row and col or new position)
  void move(int origin, int target){
    //we know it is valid at this stage, isValidMove will be called somewhere before, this is what we call once all checks are done
    //'delete' piece at origin (set to player empty)
    Piece oPiece = board[origin];
    board[origin] = Piece.empty;
    
    //call capture(target), it is being done by partner, will deal with any piece where you are going and 'capture' it
    Capture(target);
    //set target as player
    board[target] = oPiece;
  }

  /// takes row and column and returns the index of the board which represents the position.
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

  /// checks if game is over;
  /// returns -1 if game is not over;
  /// returns 0 if white won;
  /// returns 1 if black won;
  int gameWon(){
    //check if white or black lost all pieces
    if(bPieces <= 0){
      return 0;
    }
    if(wPieces <= 0){
      return 1;
    }

    //check if any black pieces are in white home and vice versa
      //black victory check
    int r = 7;
    for(int c = 0; c < 8; ++c){
      int pos = getPos(r, c);
      if(board[pos] == Piece.black){
        return 1;
      }
    }
      //white victory check
    r = 0;
    for(int c = 0; c < 8; ++c){
      int pos = getPos(r, c);
      if(board[pos] == Piece.white){
        return 0;
      }
    }
    //if at this stage, no victory yet, game continues.
    return -1;
  }

  String getStatus(){
    if(winner != Piece.empty){
      return (winner == Piece.white) ? 'White wins! (They probably cheated)' : 'Black wins! (Took them long enough.)';
    }
    else{
      return '$currentPlayer turn to play.';
    }
  }
}