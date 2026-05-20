import 'package:flutter/material.dart';

import '../models/character_avatar.dart';
import '../models/player_profile.dart';
import '../services/local_storage_service.dart';
import '../theme/minecraft_theme.dart';
import '../widgets/pixel_card.dart';
import '../widgets/primary_action_button.dart';
import 'home_screen.dart';

class PlayerSetupScreen extends StatefulWidget {
  static const String routeName = '/player-setup';

  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _playerNameController;
  String _avatarId = CharacterAvatar.fallback.id;
  int _maxHp = 100;
  int _baseDamage = 10;
  int _criticalChance = 20;
  double _criticalMultiplier = 1.5;
  int _healAmount = 5;
  int _missChance = 10;

  @override
  void initState() {
    super.initState();
    // Load existing profile if available
    final profile = localStorage.getPlayerProfile();
    if (profile != null) {
      _playerNameController = TextEditingController(text: profile.playerName);
      _avatarId = profile.avatarId;
      _maxHp = profile.maxHp;
      _baseDamage = profile.baseDamageReceived;
      _criticalChance = profile.criticalHitChance;
      _criticalMultiplier = profile.criticalDamageMultiplier;
      _healAmount = profile.healAmount;
      _missChance = profile.missChance;
    } else {
      _playerNameController = TextEditingController(text: 'Player');
    }
  }

  @override
  void dispose() {
    _playerNameController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final profile = PlayerProfile(
      playerName: _playerNameController.text.trim(),
      avatarId: _avatarId,
      maxHp: _maxHp,
      baseDamageReceived: _baseDamage,
      criticalHitChance: _criticalChance,
      criticalDamageMultiplier: _criticalMultiplier,
      healAmount: _healAmount,
      missChance: _missChance,
    );

    await localStorage.savePlayerProfile(profile);

    if (mounted) {
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    }
  }

  Widget _buildStatSlider({
    required String label,
    required int value,
    required int min,
    required int max,
    required int divisions,
    required Function(int) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: MinecraftTheme.textLight,
        border: Border.all(color: MinecraftTheme.darkBrownWood, width: 2),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: $value',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: MinecraftTheme.textDark,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 8,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 8,
                elevation: 2,
              ),
              activeTrackColor: MinecraftTheme.primaryGold,
              inactiveTrackColor: const Color(0xFFD8C7AD),
              thumbColor: MinecraftTheme.darkBrownWood,
            ),
            child: Slider(
              value: value.toDouble(),
              min: min.toDouble(),
              max: max.toDouble(),
              divisions: divisions,
              label: value.toString(),
              onChanged: (v) => onChanged(v.toInt()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterButton(CharacterAvatar character) {
    final isSelected = _avatarId == character.id;

    return GestureDetector(
      onTap: () => setState(() => _avatarId = character.id),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? MinecraftTheme.primaryGold
              : MinecraftTheme.deepStoneCharcoal,
          border: Border.all(
            color: isSelected
                ? MinecraftTheme.hpGreen
                : MinecraftTheme.darkBrownWood,
            width: isSelected ? 4 : 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: MinecraftTheme.primaryGold.withValues(alpha: 0.4),
                    offset: const Offset(2, 2),
                    blurRadius: 0,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CharacterImage(
                characterId: character.id,
                pose: CharacterPose.idle,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                character.label.toUpperCase(),
                maxLines: 1,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? MinecraftTheme.deepStoneCharcoal
                      : MinecraftTheme.warmCream,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MinecraftTheme.warmCream,
      appBar: AppBar(
        title: const Text('PLAYER SETUP'),
        elevation: 0,
        backgroundColor: MinecraftTheme.primaryGold,
        foregroundColor: MinecraftTheme.textLight,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: MinecraftTheme.textLight,
          letterSpacing: 1.5,
        ),
        toolbarHeight: 60,
        shape: Border(
          bottom: BorderSide(
            color: MinecraftTheme.deepStoneCharcoal,
            width: MinecraftTheme.chunkBorderWidth,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                // Player Name
                PixelCard(
                  borderColor: MinecraftTheme.deepStoneCharcoal,
                  backgroundColor: MinecraftTheme.darkBrownWood,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PLAYER NAME',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: MinecraftTheme.textLight,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _playerNameController,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: MinecraftTheme.warmCream,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: MinecraftTheme.textDark,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: MinecraftTheme.grassGreen,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: MinecraftTheme.primaryGold,
                              width: 3,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Player name required';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Character
                PixelCard(
                  borderColor: MinecraftTheme.deepStoneCharcoal,
                  backgroundColor: MinecraftTheme.darkBrownWood,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'CHARACTER',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: MinecraftTheme.textLight,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: MinecraftTheme.deepStoneCharcoal,
                          border: Border.all(
                            color: MinecraftTheme.primaryGold,
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: SizedBox(
                          height: 150,
                          child: CharacterImage(
                            characterId: _avatarId,
                            pose: CharacterPose.idle,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: CharacterAvatar.all.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 0.82,
                            ),
                        itemBuilder: (context, index) {
                          return _buildCharacterButton(
                            CharacterAvatar.all[index],
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        CharacterAvatar.byId(_avatarId).label.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: MinecraftTheme.primaryGold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Battle Stats Section
                PixelCard(
                  borderColor: MinecraftTheme.deepStoneCharcoal,
                  backgroundColor: MinecraftTheme.darkBrownWood,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BATTLE STATS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: MinecraftTheme.textLight,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildStatSlider(
                        label: 'Max HP',
                        value: _maxHp,
                        min: 50,
                        max: 300,
                        divisions: 25,
                        onChanged: (v) => setState(() => _maxHp = v),
                      ),
                      _buildStatSlider(
                        label: 'Base Damage',
                        value: _baseDamage,
                        min: 1,
                        max: 50,
                        divisions: 49,
                        onChanged: (v) => setState(() => _baseDamage = v),
                      ),
                      _buildStatSlider(
                        label: 'Miss Chance %',
                        value: _missChance,
                        min: 0,
                        max: 100,
                        divisions: 20,
                        onChanged: (v) => setState(() => _missChance = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Critical Stats Section
                PixelCard(
                  borderColor: MinecraftTheme.redstone,
                  backgroundColor: MinecraftTheme.darkBrownWood,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CRITICAL STRIKE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: MinecraftTheme.textLight,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildStatSlider(
                        label: 'Crit Chance %',
                        value: _criticalChance,
                        min: 0,
                        max: 100,
                        divisions: 20,
                        onChanged: (v) => setState(() => _criticalChance = v),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 0),
                        decoration: BoxDecoration(
                          color: MinecraftTheme.textLight,
                          border: Border.all(
                            color: MinecraftTheme.redstone,
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Crit Damage: ${_criticalMultiplier.toStringAsFixed(1)}x',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: MinecraftTheme.textDark,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 8,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 8,
                                ),
                                activeTrackColor: MinecraftTheme.battleRed,
                                inactiveTrackColor: const Color(0xFFD8C7AD),
                                thumbColor: MinecraftTheme.accentOrange,
                              ),
                              child: Slider(
                                value: _criticalMultiplier,
                                min: 1.0,
                                max: 3.0,
                                divisions: 20,
                                label: _criticalMultiplier.toStringAsFixed(1),
                                onChanged: (value) {
                                  setState(
                                    () => _criticalMultiplier = double.parse(
                                      value.toStringAsFixed(1),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Support Section
                PixelCard(
                  borderColor: MinecraftTheme.deepStoneCharcoal,
                  backgroundColor: MinecraftTheme.darkBrownWood,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SUPPORT',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: MinecraftTheme.textLight,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildStatSlider(
                        label: 'Heal Amount',
                        value: _healAmount,
                        min: 0,
                        max: 50,
                        divisions: 10,
                        onChanged: (v) => setState(() => _healAmount = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Save Button
                PrimaryActionButton(
                  label: 'SAVE SETTING',
                  onPressed: _saveProfile,
                  backgroundColor: MinecraftTheme.primaryGold,
                  borderColor: MinecraftTheme.deepStoneCharcoal,
                  textColor: MinecraftTheme.deepStoneCharcoal,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
