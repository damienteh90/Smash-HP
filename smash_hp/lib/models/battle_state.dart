import 'player.dart';

class BattleState {
  const BattleState({required this.players, required this.startingHp});

  final List<Player> players;
  final int startingHp;

  bool get hasKo => players.any((player) => player.hp <= 0);

  Player? get knockedOutPlayer {
    for (final player in players) {
      if (player.hp <= 0) {
        return player;
      }
    }

    return null;
  }

  BattleState damagePlayer(int index, int amount) {
    final updatedPlayers = [...players];
    final player = updatedPlayers[index];
    updatedPlayers[index] = player.copyWith(hp: player.hp - amount);

    return BattleState(players: updatedPlayers, startingHp: startingHp);
  }
}
