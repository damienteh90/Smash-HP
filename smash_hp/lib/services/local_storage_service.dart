import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/battle_session.dart';
import '../models/character_avatar.dart';
import '../models/player_profile.dart';

class LocalStorageService {
  static const String _playerProfileKey = 'player_profile';
  static const String _activeBattleSessionKey = 'active_battle_session';
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _vibrationEnabledKey = 'vibration_enabled';
  static const String _customAvatarIdlePathKey = 'custom_avatar_idle_path';
  static const String _customAvatarHitPathKey = 'custom_avatar_hit_path';
  static const String _customAvatarDeadPathKey = 'custom_avatar_dead_path';

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

  /// Clear saved player profile
  Future<void> clearPlayerProfile() async {
    if (!_initialized) throw StateError('LocalStorageService not initialized');
    await _prefs.remove(_playerProfileKey);
  }

  /// Custom avatar image paths
  CustomAvatarImages? getCustomAvatarImages() {
    if (!_initialized) throw StateError('LocalStorageService not initialized');

    final images = CustomAvatarImages(
      idlePath: _prefs.getString(_customAvatarIdlePathKey) ?? '',
      hitPath: _prefs.getString(_customAvatarHitPathKey) ?? '',
      deadPath: _prefs.getString(_customAvatarDeadPathKey) ?? '',
    );

    return images.isComplete ? images : null;
  }

  Future<void> saveCustomAvatarImages(CustomAvatarImages images) async {
    if (!_initialized) throw StateError('LocalStorageService not initialized');
    await Future.wait([
      _prefs.setString(_customAvatarIdlePathKey, images.idlePath),
      _prefs.setString(_customAvatarHitPathKey, images.hitPath),
      _prefs.setString(_customAvatarDeadPathKey, images.deadPath),
    ]);
  }

  /// Sound preference, defaults to enabled
  bool isSoundEnabled() {
    if (!_initialized) throw StateError('LocalStorageService not initialized');
    return _prefs.getBool(_soundEnabledKey) ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    if (!_initialized) throw StateError('LocalStorageService not initialized');
    await _prefs.setBool(_soundEnabledKey, enabled);
  }

  /// Vibration preference, defaults to enabled
  bool isVibrationEnabled() {
    if (!_initialized) throw StateError('LocalStorageService not initialized');
    return _prefs.getBool(_vibrationEnabledKey) ?? true;
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    if (!_initialized) throw StateError('LocalStorageService not initialized');
    await _prefs.setBool(_vibrationEnabledKey, enabled);
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
