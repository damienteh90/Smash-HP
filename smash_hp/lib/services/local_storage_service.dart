import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/battle_session.dart';
import '../models/player_profile.dart';

class LocalStorageService {
  static const String _playerProfileKey = 'player_profile';
  static const String _activeBattleSessionKey = 'active_battle_session';

  late final SharedPreferences _prefs;
  bool _initialized = false;

  /// Initialize the service (must be called before using)
  Future<void> initialize() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  /// Get saved player profile
  PlayerProfile? getPlayerProfile() {
    if (!_initialized) throw StateError('LocalStorageService not initialized');

    final jsonString = _prefs.getString(_playerProfileKey);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return PlayerProfile.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  /// Save player profile
  Future<void> savePlayerProfile(PlayerProfile profile) async {
    if (!_initialized) throw StateError('LocalStorageService not initialized');
    await _prefs.setString(_playerProfileKey, profile.toJsonString());
  }

  /// Get active battle session
  BattleSession? getActiveBattleSession() {
    if (!_initialized) throw StateError('LocalStorageService not initialized');

    final jsonString = _prefs.getString(_activeBattleSessionKey);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return BattleSession.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  /// Save active battle session
  Future<void> saveActiveBattleSession(BattleSession session) async {
    if (!_initialized) throw StateError('LocalStorageService not initialized');
    await _prefs.setString(_activeBattleSessionKey, session.toJsonString());
  }

  /// Clear active battle session
  Future<void> clearActiveBattleSession() async {
    if (!_initialized) throw StateError('LocalStorageService not initialized');
    await _prefs.remove(_activeBattleSessionKey);
  }

  /// Clear all data
  Future<void> clearAll() async {
    if (!_initialized) throw StateError('LocalStorageService not initialized');
    await _prefs.clear();
  }
}

final localStorage = LocalStorageService();
