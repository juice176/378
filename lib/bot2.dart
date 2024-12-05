import 'dart:math';
import 'player.dart';
import 'game.dart';
class Bot2 extends Player {
  Bot2(super.name, super.game);
  int? lastNearMissGuess;
  @override
  Future<void> makeGuess() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate waiting for the bot to make a guess
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
      return;
    }
    if(game.isAdjacentToGopher(guess)){
      lastNearMissGuess = guess;
      print('$name guessed position $guess, which was a near-miss.');
    }else{
      print('$name guessed position $guess, but missed.');
    }
    game.bot2Guesses.add(guess);

    // Notify UI to update after the guess
    game.startBotTurn();

  }

  // Helper function to get a guess that's adjacent to the given position
  int _getAdjacentGuess(int previousGuess) {
    List<int> adjacentPositions = game.getAdjacentPositions(previousGuess);

    // Filter out positions that have already been guessed
    adjacentPositions = adjacentPositions
        .where((pos) => !game.bot2Guesses.contains(pos))
        .toList();



    // Return a random adjacent position
    return adjacentPositions[Random().nextInt(adjacentPositions.length)];
  }

  @override
  Future<void> reset() async {
    game.bot2Guesses.clear();
  }
}


