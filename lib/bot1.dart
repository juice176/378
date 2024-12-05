import 'player.dart';
import 'dart:math';
import 'game.dart';
class Bot1 extends Player {
  Bot1(super.name, super.game);
  int? lastNearMissGuess;
  List<int>adjacentGuesses = [];
  @override
  Future<void> makeGuess() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate waiting for the bot to make a guess
    int guess;

    // If no near-miss, make a random guess
    if (lastNearMissGuess ==  null) {
      guess = Random().nextInt(Game.gridSize * Game.gridSize);
      print('$name made a random guess at position $guess');
    } else {

      // If there was a near-miss, get the first unguessed adjacent guess
      guess = _getAdjacentGuess(lastNearMissGuess!);
    }
    if(game.isAdjacentToGopher(guess)){
      lastNearMissGuess = guess;
      print('$name guessed position $guess, which was a near-miss.');
      guess = _getAdjacentGuess(lastNearMissGuess!);
    }
    // Check if the guess is correct (game over)
    else if (game.checkGuess(guess)) {
      game.bot1Guesses.add(guess);
      game.isGameOver = true;
      print('$name found the gopher at position $guess!');
      reset(); // Reset after finding the gopher
    }
    else if (game.isAdjacentToGopher(guess)) {
      // If it's a near-miss, update lastNearMissGuess
      lastNearMissGuess = guess;
      print('$name guessed position $guess, which was a near-miss.');
    } else {
      // If the guess was wrong, just print and continue
      print('$name guessed position $guess, but missed.');
    }

    // Add the guess to the bot's list of guesses
    game.bot1Guesses.add(guess);

    // Notify the game that the bot's turn is over
    game.startBotTurn();
  }
  @override
  Future<void> reset() async {
    lastNearMissGuess = null;
  }
  // Helper function to get a guess that's adjacent to the given position
  List<int> getAdjacentPositions(int index) {
    int row = index ~/ 10;
    int col = index % 10;

    List<int> adjacentPositions = [];

    for (int r = row - 1; r <= row + 1; r++) {
      for (int c = col - 1; c <= col + 1; c++) {
        if (r >= 0 && r < 10 && c >= 0 && c < 10) {
          int adjacentIndex = r * 10 + c;
          // Avoid guessing the same position again
          adjacentPositions.add(adjacentIndex);
        }
      }
    }

    return adjacentPositions;
  }
  // Helper function to get a guess that's adjacent to the given position
  int _getAdjacentGuess(int prevguess) {
    List<int> adjacentPositions = getAdjacentPositions(prevguess);
    print('Available adjacent positions Bot 1: $adjacentPositions');
    // Filter out positions that have already been guessed
    adjacentPositions = adjacentPositions
        .where((pos) => !game.bot1Guesses.contains(pos))
        .toList();

    if (adjacentGuesses.isEmpty && adjacentPositions.isNotEmpty) {
      adjacentGuesses = adjacentPositions;
      print('Storing unguessed adjacent positions: $adjacentGuesses');
    }

    // If there are still unguessed adjacent positions, take the next one
    if (adjacentGuesses.isNotEmpty) {
      int nextGuess = adjacentGuesses.removeAt(0); // Get the next adjacent square
      print('$name is going to guess $nextGuess from the adjacent list.');
      return nextGuess;
    }
    return Random().nextInt(Game.gridSize * Game.gridSize);
    // Return a random adjacent position
    //return adjacentPositions[Random().nextInt(adjacentPositions.length)];
  }
}
