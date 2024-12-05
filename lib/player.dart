import 'game.dart';

abstract class Player{
  late final String name;
  late final Game game;

  Player(this.name,this.game);

  Future<void> makeGuess();

  Future<void> reset();
}