import '../models/battle_state.dart';
import '../models/player.dart';

class LocalStorageService {
  BattleState? _battleState;

  BattleState get battleState {
    return _battleState ??
        const BattleState(
          players: [
            Player(name: 'Player 1', hp: 100),
            Player(name: 'Player 2', hp: 100),
          ],
          startingHp: 100,
        );
  }

  void saveBattleState(BattleState battleState) {
    _battleState = battleState;
  }

  void resetBattle() {
    _battleState = null;
  }
}
