enum Piece {
  empty(' '),
  white('White'),
  black('Black');

  final String str;

  const Piece(this.str);

  @override
  String toString() => str;
}

class BreakthroughState {
  //var board = List.generate(8, (size) => size * size, growable: false);
  late List<Piece> board;
  static const rows = 8;
  static const cols = 8;
  static const numCells = rows * cols;
  //row = pos/cols
  //col = pos % cols
  //pos = r * cols + c
  int wPieces = 0;
  int bPieces = 0;
  late Piece currentPlayer, winner;
  //-1 = no piece selected.
  int selection = -1;

  BreakthroughState() {
    newGame();
  }

  void newGame() {
    //initalize key variables
    selection = -1;
    wPieces = 0;
    bPieces = 0;
    currentPlayer = Piece.white;
    winner = Piece.empty;
    board = List<Piece>.filled(64, Piece.empty);

    //generate black pieces
    int r = 6;
    int c = 0;
    while (bPieces < 16) {
      int pos = r * cols + c;
      board[pos] = Piece.black;
      ++c;
      if (c > 7) {
        //c = 8, end of board
        c = 0;
        ++r;
      }
      ++bPieces;
    }

    //generate white pieces
    r = 0;
    c = 0;
    while (wPieces < 16) {
      int pos = r * cols + c;
      board[pos] = Piece.white;
      ++c;
      if (c > 7) {
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

  int getCol(int pos) {
    return pos % cols;
  }

  Piece getWinner() => winner;

  ///move method(origin pos, row and col or new position)
  void move(int origin, int target) {
    //save old piece and remove it from original position
    Piece oPiece = board[origin];
    board[origin] = Piece.empty;

    //'capture' piece if target is occupied
    capture(target);

    //set target as player
    board[target] = oPiece;
  }

  void capture(int target) {
    if (board[target] == Piece.white) {
      --wPieces;
    } else if (board[target] == Piece.black) {
      --bPieces;
    }
  }

  /// takes row and column and returns the index of the board which represents the position.
  int getPos(int row, int col) {
    return (row * cols + col);
  }

  bool playAt(int index) {
    if(winner != Piece.empty){
      return false;
    }
    if (selection == -1) {
      //make a selection
      //check if selected tile has correct piece
      if (currentPlayer == board[index]) {
        selection = index;
        return true;
      }
    } 
    else {
      //check if move is valid
      bool isWhite = (currentPlayer == Piece.white) ? true : false;
      if (isValidMove(selection, index, isWhite)) {
        //valid move, move.
        move(selection, index);
        //move made, reset selection
        selection = -1;
        currentPlayer =
            (currentPlayer == Piece.white) ? Piece.black : Piece.white;
        gameWon();
        return true;
      } 
      else {
        //invalid move
        selection = -1;
        //System.out.println("Invalid Move.");
        return false;
      }
    }
    return false;
  }

  bool isValidMove(int origin, int target, bool isWhite) {
    //assemble list of valid moves
    List<int> validMoves = List<int>.empty();
    int oRow = getRow(origin);
    int oCol = getCol(origin);
    if (!isWhite) {
      //piece is moving 'up'

      //diag left (-1 row, -1 col)
      if (oCol != 0) {
        //if == 0, can't move diag left
        int newMove = getPos(oRow - 1, oCol - 1);
        if (board[newMove] != Piece.black) {
          //not occupied by different piece of same team.
          validMoves.add(newMove);
        }
      }
      //forward, no check for ANY piece
      int newMove = getPos(oRow - 1, oCol);
      if (board[newMove] == Piece.empty) {
        validMoves.add(newMove);
      }

      //diag right (-1 row, +1 col)
      if (oCol != 7) {
        //if == 7, can't move diag right
        int newMove = getPos(oRow - 1, oCol + 1);
        if (board[newMove] != Piece.black) {
          //not occupied by different piece of same team.
          validMoves.add(newMove);
        }
      }
    }

    if (isWhite) {
      //piece is moving 'down'

      //diag left (+1 row, -1 col)
      if (oCol != 0) {
        //if == 0, can't move diag left
        int newMove = getPos(oRow + 1, oCol - 1);
        if (board[newMove] != Piece.white) {
          //not occupied by different piece of same team.
          validMoves.add(newMove);
        }
      }
      //forward, check if ANY piece there
      int newMove = getPos(oRow + 1, oCol);
      if (board[newMove] == Piece.empty) {
        validMoves.add(newMove);
      }

      //diag right (+1 row, +1 col)
      if (oCol != 7) {
        //if == 7, can't move diag right
        int newMove = getPos(oRow + 1, oCol + 1);
        if (board[newMove] != Piece.white) {
          //not occupied by different piece of same team.
          validMoves.add(newMove);
        }
      }
    }

    //validMoves found, check if target move is one of them.
    return validMoves.contains(target);
  }

  /// checks if game is over;
  bool gameWon() {
    //check if white or black lost all pieces
    if (bPieces <= 0) {
      winner = Piece.white;
      return true;
    }
    else if (wPieces <= 0) {
      winner = Piece.black;
      return true;
    }

    //check if any black pieces are in white home and vice versa
    //white victory check
    int r = 7;
    for (int c = 0; c < 8; ++c) {
      int pos = getPos(r, c);
      if (board[pos] == Piece.white) {
        winner = Piece.white;
        return true;
      }
    }
    //black victory check
    r = 0;
    for (int c = 0; c < 8; ++c) {
      int pos = getPos(r, c);
      if (board[pos] == Piece.black) {
        winner = Piece.black;
        return true;
      }
    }
    //if at this stage, no victory yet, game continues.
    return false;
  }

  String getStatus() {
    if (winner != Piece.empty) {
      return (winner == Piece.white)
          ? 'White wins!'
          : 'Black wins!';
    } else {
      return '$currentPlayer`s turn to play.';
    }
  }
}
