import 'dart:math';
import 'player.dart';
import 'game.dart';
class Bot2 extends Player {
  Bot2(super.name, super.game);
  int? lastNearMissGuess;
  @override
  Future<void> makeGuess() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate waiting for the bot to make a guess
    int guess;

    if(lastNearMissGuess == null){
      guess = Random().nextInt(Game.gridSize * Game.gridSize);
    }
    else{
      guess = _getAdjacentGuess(lastNearMissGuess!);
    }
    // If the guess is correct, end the game
    if (game.checkGuess(guess)) {
      game.bot2Guesses.add(guess);
      game.isGameOver = true;
      print('$name found the gopher at position $guess!');
      reset();
    }
    if(game.isAdjacentToGopher(guess)){
      lastNearMissGuess = guess;
      game.bot2Guesses.add(guess);
      guess = _getAdjacentGuess(lastNearMissGuess!);
      print('$name guessed position $guess, which was a near-miss.');
    }else{
      print('$name guessed position $guess, but missed.');
      game.bot2Guesses.add(guess);
    }


    // Notify UI to update after the guess
    game.startBotTurn();

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
  int _getAdjacentGuess(int previousGuess) {
    List<int> adjacentPositions = getAdjacentPositions(previousGuess);

    // Filter out positions that have already been guessed
    adjacentPositions = adjacentPositions
        .where((pos) => !game.bot2Guesses.contains(pos))
        .toList();



    // Return a random adjacent position
    return adjacentPositions[Random().nextInt(adjacentPositions.length)];
  }

  @override
  Future<void> reset() async {
    lastNearMissGuess = null;
  }
}


