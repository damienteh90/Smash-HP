import 'dart:convert';

class BattleLogEntry {
  final String message;
  final int hpBefore;
  final int hpAfter;
  final DateTime timestamp;

  const BattleLogEntry({
    required this.message,
    required this.hpBefore,
    required this.hpAfter,
    required this.timestamp,
  });

  factory BattleLogEntry.fromJson(Map<String, dynamic> json) {
    return BattleLogEntry(
      message: json['message'] as String,
      hpBefore: json['hpBefore'] as int,
      hpAfter: json['hpAfter'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'hpBefore': hpBefore,
      'hpAfter': hpAfter,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class BattleSession {
  final int currentHp;
  final int maxHp;
  final int roundNumber;
  final List<BattleLogEntry> battleLog;
  final List<int> undoStack; // stores HP values for undo
  final bool isKo;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BattleSession({
    required this.currentHp,
    required this.maxHp,
    required this.roundNumber,
    required this.battleLog,
    required this.undoStack,
    required this.isKo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BattleSession.initial({required int maxHp}) {
    return BattleSession(
      currentHp: maxHp,
      maxHp: maxHp,
      roundNumber: 1,
      battleLog: [],
      undoStack: [],
      isKo: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  factory BattleSession.fromJson(Map<String, dynamic> json) {
    return BattleSession(
      currentHp: json['currentHp'] as int,
      maxHp: json['maxHp'] as int,
      roundNumber: json['roundNumber'] as int,
      battleLog: (json['battleLog'] as List<dynamic>)
          .map((e) => BattleLogEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      undoStack: List<int>.from(json['undoStack'] as List<dynamic>),
      isKo: json['isKo'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentHp': currentHp,
      'maxHp': maxHp,
      'roundNumber': roundNumber,
      'battleLog': battleLog.map((e) => e.toJson()).toList(),
      'undoStack': undoStack,
      'isKo': isKo,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String toJsonString() => jsonEncode(toJson());

  BattleSession copyWith({
    int? currentHp,
    int? maxHp,
    int? roundNumber,
    List<BattleLogEntry>? battleLog,
    List<int>? undoStack,
    bool? isKo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BattleSession(
      currentHp: currentHp ?? this.currentHp,
      maxHp: maxHp ?? this.maxHp,
      roundNumber: roundNumber ?? this.roundNumber,
      battleLog: battleLog ?? this.battleLog,
      undoStack: undoStack ?? this.undoStack,
      isKo: isKo ?? this.isKo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
