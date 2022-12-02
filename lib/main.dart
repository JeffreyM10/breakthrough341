import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Epic Breakthrough Game (18+)',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Breakthrough'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

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
    int getRow(int pos) {
      return pos/cols;
    }

    int getCol(int pos){
      return pos%cols;
    }
    //move method(row, col, piece)
    void move(int row, int col){
      if(isValidMove() == true) {
       
      }

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
      //forward, no check needed
      int newMove = getPos(oRow + 1, oCol);
      if(board[newMove] != Piece.white){
        validMoves.add(newMove);
      }
    }
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Piece> pieces = [];
  var board = List.generate(8, (size) => size * size, growable: false);

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
