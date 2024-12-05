import 'main.dart';
import 'player.dart';
import 'dart:math';
import 'game.dart';
class Bot1 extends Player {
  Bot1(super.name, super.game);
  int? lastNearMissGuess;
  @override
  Future<void> makeGuess() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate waiting for the bot to make a guess
    int guess;

    if(lastNearMissGuess == null){ // if no near guess then make random
      guess = Random().nextInt(Game.gridSize * Game.gridSize);
    }
    else{
      guess = _getAdjacentGuess(lastNearMissGuess!);
    }
    // If the guess is correct, end the game
    if (game.checkGuess(guess)) {
      game.bot1Guesses.add(guess);
      game.isGameOver = true;
      print('$name found the gopher at position $guess!');
      return;
    }
    if(game.isAdjacentToGopher(guess)){
      lastNearMissGuess = guess;
      print('$name guessed position $guess, which was a near-miss.');
    }else{
      print('$name guessed position $guess, but missed.');
    }
    // If the guess is incorrect, mark the guess as false
    game.bot1Guesses.add(guess);

    // Notify UI to update after the guess
    game.startBotTurn();
  }
  @override
  Future<void> reset() async {
    // Reset Bot1 state (e.g., clear guesses)
    game.bot1Guesses.clear();
  }
  // Helper function to get a guess that's adjacent to the given position
  int _getAdjacentGuess(int previousGuess) {
    List<int> adjacentPositions = game.getAdjacentPositions(previousGuess);

    // Filter out positions that have already been guessed
    adjacentPositions = adjacentPositions
        .where((pos) => !game.bot1Guesses.contains(pos))
        .toList();

    // Return a random adjacent position
    return adjacentPositions[Random().nextInt(adjacentPositions.length)];
  }
}
