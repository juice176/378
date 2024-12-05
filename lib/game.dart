import 'bot1.dart';
import 'bot2.dart';
import 'dart:math';
import 'main.dart';
import 'player.dart';
import 'package:flutter/material.dart';
class Game {
  static const int gridSize = 10;
  int gopherPosition = -1;
  List<int> bot1Guesses = []; // Track guesses by Bot1
  List<int> bot2Guesses = []; // Track guesses by Bot2
  bool isGameOver = false;
  late Bot1 bot1;
  late Bot2 bot2;
  int turnCounter = 0;
  late Player currentPlayer;

  final Function updateUI;

  Game(this.updateUI) {
    _initializeGame();

  }

  void _initializeGame() {
    gopherPosition = Random().nextInt(gridSize * gridSize);
    currentPlayer = Bot1("Bot1", this);
    isGameOver = false;
    bot1Guesses.clear();
    bot2Guesses.clear();
  }

  Future<void> startBotTurn() async {
    if (isGameOver) return;

    await currentPlayer.makeGuess();


    // Check if the game is over
    if (bot1Guesses.contains(gopherPosition) ||
        bot2Guesses.contains(gopherPosition)) {
      isGameOver = true;
      _initializeGame();

    }

    updateUI();
    // Switch to the other player's turn
    if (currentPlayer is Bot1) {
      currentPlayer = Bot2("Bot2", this);
    } else {
      currentPlayer = Bot1("Bot1", this);
    }
  }

  void resetGame() {
    _initializeGame();
    currentPlayer.reset();
    updateUI();
  }

  bool checkGuess(int guessIndex) {
    return guessIndex == gopherPosition;
  }

  // Get Bot1's guesses color
  Color getBot1CellColor(int index) {
    if (bot1Guesses.contains(index)) {
      if (index == gopherPosition) {
        return Colors.green;
      }
      else if (isAdjacentToGopher(index)) {
        return Colors.orange;
      }
      else {
        return Colors.red;
      }
    }
    else {
      return Colors.grey; // Un-guessed cells
    }
  }

  // Get Bot2's guesses color
  Color getBot2CellColor(int index) {
    if (bot2Guesses.contains(index)) {
      if (index == gopherPosition) {
        return Colors.green;
      }
      else if (isAdjacentToGopher(index)) {
        return Colors.blue;
      }
      else {
        return Colors.purple;
      }
    } else {
      return Colors.grey; // Un-guessed cells
    }
  }

bool isAdjacentToGopher(int index) {
  int row = index ~/ gridSize;
  int col = index % gridSize;
  int gopherRow = gopherPosition ~/ gridSize;
  int gopherCol = gopherPosition % gridSize;

  // Check if adjacent
  return (row - gopherRow).abs() <= 1 && (col - gopherCol).abs() <= 1;
}

}