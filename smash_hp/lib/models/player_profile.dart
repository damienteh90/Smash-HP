import 'dart:convert';

import 'character_avatar.dart';

class PlayerProfile {
  final String playerName;
  final String avatarId;
  final int maxHp;
  final int baseDamageReceived;
  final int criticalHitChance; // percentage 0-100
  final double criticalDamageMultiplier;
  final int healAmount;
  final int missChance; // percentage 0-100

  const PlayerProfile({
    required this.playerName,
    required this.avatarId,
    required this.maxHp,
    required this.baseDamageReceived,
    required this.criticalHitChance,
    required this.criticalDamageMultiplier,
    required this.healAmount,
    required this.missChance,
  });

  factory PlayerProfile.fromJson(Map<String, dynamic> json) {
    return PlayerProfile(
      playerName: json['playerName'] as String,
      avatarId: CharacterAvatar.normalizeId(json['avatarId']),
      maxHp: json['maxHp'] as int,
      baseDamageReceived: json['baseDamageReceived'] as int,
      criticalHitChance: json['criticalHitChance'] as int,
      criticalDamageMultiplier: (json['criticalDamageMultiplier'] as num)
          .toDouble(),
      healAmount: json['healAmount'] as int,
      missChance: json['missChance'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playerName': playerName,
      'avatarId': avatarId,
      'maxHp': maxHp,
      'baseDamageReceived': baseDamageReceived,
      'criticalHitChance': criticalHitChance,
      'criticalDamageMultiplier': criticalDamageMultiplier,
      'healAmount': healAmount,
      'missChance': missChance,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  PlayerProfile copyWith({
    String? playerName,
    String? avatarId,
    int? maxHp,
    int? baseDamageReceived,
    int? criticalHitChance,
    double? criticalDamageMultiplier,
    int? healAmount,
    int? missChance,
  }) {
    return PlayerProfile(
      playerName: playerName ?? this.playerName,
      avatarId: avatarId ?? this.avatarId,
      maxHp: maxHp ?? this.maxHp,
      baseDamageReceived: baseDamageReceived ?? this.baseDamageReceived,
      criticalHitChance: criticalHitChance ?? this.criticalHitChance,
      criticalDamageMultiplier:
          criticalDamageMultiplier ?? this.criticalDamageMultiplier,
      healAmount: healAmount ?? this.healAmount,
      missChance: missChance ?? this.missChance,
    );
  }
}
