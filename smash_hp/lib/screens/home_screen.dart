import 'package:flutter/material.dart';

import '../models/character_avatar.dart';
import '../services/local_storage_service.dart';
import '../theme/minecraft_theme.dart';
import '../widgets/pixel_card.dart';
import '../widgets/primary_action_button.dart';
import 'battle_screen.dart';
import 'player_setup_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _startBattle() {
    final profile = localStorage.getPlayerProfile();
    if (profile != null) {
      // Start/resume battle with saved profile
      Navigator.of(context).pushNamed(BattleScreen.routeName);
    } else {
      // No profile exists, go to setup
      Navigator.of(context).pushNamed(PlayerSetupScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final savedProfile = localStorage.getPlayerProfile();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: MinecraftTheme.warmCream,
        appBar: AppBar(
          title: const Text('SMASH HP'),
          elevation: 0,
          backgroundColor: MinecraftTheme.primaryGold,
          foregroundColor: MinecraftTheme.textLight,
          automaticallyImplyLeading: false,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 24,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                if (savedProfile != null) ...[
                  Text(
                    'SAVED PROFILE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MinecraftTheme.textDark,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  PixelCard(
                    borderColor: MinecraftTheme.deepStoneCharcoal,
                    backgroundColor: MinecraftTheme.darkBrownWood,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 120,
                          child: CharacterImage(
                            characterId: savedProfile.avatarId,
                            pose: CharacterPose.idle,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          savedProfile.playerName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: MinecraftTheme.textLight,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: MinecraftTheme.healthGreen,
                            border: Border.all(
                              color: MinecraftTheme.darkGreen,
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: Text(
                            'MAX HP: ${savedProfile.maxHp}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: MinecraftTheme.textLight,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ] else ...[
                  const SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      color: MinecraftTheme.warnYellow,
                      border: Border.all(
                        color: MinecraftTheme.textDark,
                        width: MinecraftTheme.chunkBorderWidth,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'NO SAVED PROFILE YET',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: MinecraftTheme.textDark,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                PrimaryActionButton(
                  label: 'PLAYER SETUP',
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pushNamed(PlayerSetupScreen.routeName);
                  },
                  backgroundColor: MinecraftTheme.darkBrownWood,
                  borderColor: MinecraftTheme.deepStoneCharcoal,
                ),
                const SizedBox(height: 16),
                PrimaryActionButton(
                  label: 'START BATTLE',
                  onPressed: _startBattle,
                  backgroundColor: MinecraftTheme.hpGreen,
                  borderColor: MinecraftTheme.deepStoneCharcoal,
                  textColor: MinecraftTheme.deepStoneCharcoal,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
