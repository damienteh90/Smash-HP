import 'dart:math';

import '../models/battle_session.dart';
import '../models/player_profile.dart';

class BattleLogic {
  static final Random _random = Random();

  /// Calculate damage and apply attack
  /// Returns tuple: (newHp, logMessage, damageDealt, wasMiss, wasCritical)
  static (int, String, int, bool, bool) calculateAttack(
    PlayerProfile profile,
    BattleSession session,
  ) {
    final hpBefore = session.currentHp;

    // Roll for miss
    final missRoll = _random.nextInt(100);
    if (missRoll < profile.missChance) {
      return (hpBefore, 'Miss!', 0, true, false);
    }

    // Roll for critical hit
    final critRoll = _random.nextInt(100);
    final isCritical = critRoll < profile.criticalHitChance;

    int damage;
    if (isCritical) {
      damage = (profile.baseDamageReceived * profile.criticalDamageMultiplier)
          .toInt();
    } else {
      damage = profile.baseDamageReceived;
    }

    // Apply damage (don't go below 0)
    final newHp = max(0, hpBefore - damage);

    String logMessage;
    if (isCritical) {
      logMessage = 'Critical Hit! -$damage HP';
    } else {
      logMessage = 'Attack! -$damage HP';
    }

    return (newHp, logMessage, damage, false, isCritical);
  }

  /// Add attack result to battle session
  static BattleSession applyAttack(
    BattleSession session,
    PlayerProfile profile,
    int newHp,
    String logMessage,
  ) {
    final updatedLog = [
      ...session.battleLog,
      BattleLogEntry(
        message: logMessage,
        hpBefore: session.currentHp,
        hpAfter: newHp,
        timestamp: DateTime.now(),
      ),
    ];

    // Add current HP to undo stack before updating
    final updatedUndoStack = [...session.undoStack, session.currentHp];

    final isKo = newHp <= 0;

    return session.copyWith(
      currentHp: newHp,
      battleLog: updatedLog,
      undoStack: updatedUndoStack,
      isKo: isKo,
      updatedAt: DateTime.now(),
    );
  }

  /// Undo last action
  static BattleSession? undo(BattleSession session) {
    if (session.undoStack.isEmpty) {
      return null;
    }

    final previousHp = session.undoStack.last;
    final updatedUndoStack = session.undoStack.sublist(
      0,
      session.undoStack.length - 1,
    );

    // Remove last log entry
    final updatedLog = session.battleLog.isNotEmpty
        ? session.battleLog.sublist(0, session.battleLog.length - 1)
        : <BattleLogEntry>[];

    return session.copyWith(
      currentHp: previousHp,
      battleLog: updatedLog,
      undoStack: updatedUndoStack,
      isKo: previousHp > 0,
      updatedAt: DateTime.now(),
    );
  }

  /// Start new round
  static BattleSession newRound(BattleSession session) {
    return session.copyWith(
      roundNumber: session.roundNumber + 1,
      currentHp: session.maxHp,
      battleLog: [],
      undoStack: [],
      isKo: false,
      updatedAt: DateTime.now(),
    );
  }
}
