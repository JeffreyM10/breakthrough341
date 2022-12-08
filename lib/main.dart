import 'package:flutter/material.dart';
//import 'package:breakthrough_state.dart';
//import 'package:flutter/services.dart';

import 'breakthrough_state.dart';

final imageMap = {
  Piece.white: Image.asset("assets/white.png"),
  Piece.black: Image.asset("assets/black.png")
};

void main() {
  runApp(const MyApp());
}
//have two grids on top of each other one is doing alternate colors depending on whether the sum of the row + col odd or even. and stack on top of that any images that would be the pieces for the player.

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

class _MyHomePageState extends State<MyHomePage> {
  final _gameState = BreakthroughState();
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
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 150.0, minHeight: 150.0),
            child: AspectRatio(
              aspectRatio: 5 / 6,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Stack(
                            children: [
                              Image.asset('assets/board.png'),
                              GridView.builder(
                                  itemCount: BreakthroughState.numCells,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              BreakthroughState.rows),
                                  itemBuilder: (context, index) {
                                    return TextButton(
                                      onPressed: () => _processPress(index),
                                      child:
                                          imageMap[_gameState.board[index]] ??
                                              Container(),
                                    );
                                  })
                            ],
                          )),
                    ),
                    Container(
                        margin: const EdgeInsets.all(10.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  _gameState.getStatus(),
                                  style: const TextStyle(fontSize: 36),
                                ),
                              ),
                              //reset button
                              const Spacer(),
                              ElevatedButton(
                                onPressed: _resetGame,
                                child: const Text(
                                  'Reset',
                                  style: TextStyle(fontSize: 36),
                                ),
                              )
                            ]))
                  ]),
            ),
          ),
        ));
  }

  void _processPress(int index) {
    setState(() {
      _gameState.playAt(index);
    });
  }

  void _resetGame() {
    setState(() {
      _gameState.newGame();
    });
  }
}
