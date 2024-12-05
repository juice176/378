import 'package:flutter/material.dart';
import 'game.dart';

void main() {
  runApp(const GopherHuntingApp());
}

class GopherHuntingApp extends StatelessWidget {
  const GopherHuntingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GopherHuntingGame(),
    );
  }
}
class GopherHuntingGame extends StatefulWidget {
  const GopherHuntingGame({super.key});

  @override
  _GopherHuntingGameState createState() => _GopherHuntingGameState();
}

class _GopherHuntingGameState extends State<GopherHuntingGame> {
  late Game _game;
  bool isGameStarted = false;
  @override
  void initState() {
    super.initState();
    _game = Game(updateUI);
  }
  void updateUI() {
    setState(() {});
  }
  // Start a new game
  void startNewGame() {
    setState(() {
      isGameStarted = true;
      _game.isGameOver = false;
    });

    // Reset the game and players
    _game.resetGame();
    _game.startBotTurn();
  }

  // Stop the game
  void stopGame() {
    setState(() {
      isGameStarted = false;
      _game.isGameOver = true;
    });

    // Show a snackbar indicating the game has been stopped
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Game stopped! The game will reset.")),
    );

    // Reset the game state
    _game.resetGame();
  }

  // Exit the game
  void exitGame() {
    Navigator.of(context).pop();  // Close the app
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [
              IconButton(onPressed: exitGame,
                icon: const Icon(Icons.exit_to_app),
              ),
            ],
            title: const Text('Gopher Hunting Game'),
            floating: true,
            expandedHeight: 100.0,
          ),
          SliverGrid(
              delegate: SliverChildBuilderDelegate(
                  (context,index){
                    return GestureDetector(
                      onTap: (){},
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: _game.getBot1CellColor(index),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            '$index',
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: Game.gridSize * Game.gridSize,

            ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Game.gridSize,
                childAspectRatio: 1.0,
              ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Bot 2\'s Grid', style: TextStyle(fontSize:20)),
            ),
          ),
          // SliverGrid for Bot2's Grid
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: _game.getBot2CellColor(index),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        '$index',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                );
              },
              childCount: Game.gridSize * Game.gridSize, // Number of items in the grid
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Game.gridSize,
              childAspectRatio: 1.0,
            ),
          ),

          // Spacer for additional space (you can adjust as needed)
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: isGameStarted || _game.isGameOver ? null : startNewGame,
              child: const Text('Start Game'),
            ),
            ElevatedButton(
              onPressed: isGameStarted && !_game.isGameOver ? stopGame : null,
              child: const Text('Stop Game'),
            ),
          ],
        ),
      ),
    );
  }
}








