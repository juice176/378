import 'game.dart';

abstract class Player{
  late final String name;
  late final Game game;

  Player(this.name,this.game);

  // Method for bots to make a guess (abstract method)
  Future<void> makeGuess();

  Future<void> reset();
}