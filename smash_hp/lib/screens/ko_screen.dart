import 'package:flutter/material.dart';

import '../models/character_avatar.dart';
import '../services/battle_logic.dart';
import '../services/local_storage_service.dart';
import '../theme/minecraft_theme.dart';
import '../widgets/pixel_button.dart';
import '../widgets/pixel_card.dart';
import 'battle_screen.dart';
import 'home_screen.dart';

class KoScreen extends StatelessWidget {
  static const String routeName = '/ko';

  const KoScreen({super.key});

  void _restartBattle(BuildContext context) async {
    final session = localStorage.getActiveBattleSession();
    if (session != null) {
      final newSession = BattleLogic.newRound(session);
      await localStorage.saveActiveBattleSession(newSession);

      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(BattleScreen.routeName);
      }
    }
  }

  void _backToHome(BuildContext context) async {
    await localStorage.clearActiveBattleSession();
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = localStorage.getPlayerProfile();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: MinecraftTheme.koBackground,
        appBar: AppBar(
          title: const Text('K.O.!!!'),
          elevation: 0,
          backgroundColor: MinecraftTheme.deepStoneCharcoal,
          foregroundColor: MinecraftTheme.criticalRed,
          automaticallyImplyLeading: false,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: MinecraftTheme.criticalRed,
            letterSpacing: 2.0,
          ),
          toolbarHeight: 64,
          shape: Border(
            bottom: BorderSide(
              color: MinecraftTheme.primaryGold,
              width: MinecraftTheme.chunkBorderWidth,
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: PixelCard(
                borderColor: MinecraftTheme.deepStoneCharcoal,
                backgroundColor: MinecraftTheme.warmCream,
                padding: const EdgeInsets.all(16),
                shadowOffset: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Dramatic Icon
                    SizedBox(
                      height: 140,
                      child: CharacterImage(
                        characterId:
                            profile?.avatarId ?? CharacterAvatar.fallback.id,
                        pose: CharacterPose.dead,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // K.O. Text
                    Text(
                      'K.O.!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: MinecraftTheme.battleRed,
                        letterSpacing: 2.0,
                        shadows: [
                          Shadow(
                            color: MinecraftTheme.deepStoneCharcoal.withValues(
                              alpha: 0.8,
                            ),
                            offset: const Offset(3, 3),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Player Name + Message
                    Container(
                      decoration: BoxDecoration(
                        color: MinecraftTheme.deepStoneCharcoal,
                        border: Border.all(
                          color: MinecraftTheme.primaryGold,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: MinecraftTheme.darkBrownWood.withValues(
                              alpha: 0.3,
                            ),
                            offset: const Offset(2, 2),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            profile?.playerName ?? 'Player',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: MinecraftTheme.warmCream,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'IS DEFEATED!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: MinecraftTheme.primaryGold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Action Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 56,
                            child: PixelButton(
                              label: 'NEW ROUND',
                              onPressed: () => _restartBattle(context),
                              isPrimary: true,
                              backgroundColor: MinecraftTheme.battleRed,
                              borderColor: MinecraftTheme.deepStoneCharcoal,
                              padding: 12,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 48,
                            child: PixelButton(
                              label: 'BACK TO HOME',
                              onPressed: () => _backToHome(context),
                              isPrimary: false,
                              backgroundColor: MinecraftTheme.darkBrownWood,
                              borderColor: MinecraftTheme.deepStoneCharcoal,
                              padding: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
