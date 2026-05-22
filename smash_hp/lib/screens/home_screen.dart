import 'package:flutter/material.dart';

import '../models/character_avatar.dart';
import '../services/local_storage_service.dart';
import '../theme/minecraft_theme.dart';
import 'battle_screen.dart';
import 'player_setup_screen.dart';
import 'settings_screen.dart';

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
    final customAvatarImages = localStorage.getCustomAvatarImages();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: MinecraftTheme.warmCream,
        appBar: AppBar(
          title: const Text('SMASH HP'),
          elevation: 0,
          backgroundColor: MinecraftTheme.primaryGold,
          foregroundColor: MinecraftTheme.deepStoneCharcoal,
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: const Icon(
            Icons.menu,
            color: MinecraftTheme.deepStoneCharcoal,
            size: 28,
          ),
          actions: [
            IconButton(
              tooltip: 'Settings',
              onPressed: () {
                Navigator.of(context).pushNamed(SettingsScreen.routeName);
              },
              icon: const Icon(
                Icons.settings,
                color: MinecraftTheme.deepStoneCharcoal,
                size: 26,
              ),
            ),
          ],
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: MinecraftTheme.deepStoneCharcoal,
            letterSpacing: 0.8,
          ),
          toolbarHeight: 52,
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
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: MinecraftTheme.darkBrownWood.withValues(
                        alpha: 0.28,
                      ),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 22),
                  _HomePanel(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 120,
                          child: CharacterImage(
                            characterId: savedProfile.avatarId,
                            pose: CharacterPose.idle,
                            customAvatarImages: customAvatarImages,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          savedProfile.playerName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: MinecraftTheme.deepStoneCharcoal,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: MinecraftTheme.hpGreen,
                            border: Border.all(
                              color: MinecraftTheme.deepStoneCharcoal,
                              width: 3,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xFF2A1D12),
                                offset: Offset(3, 3),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Text(
                            'MAX HP: ${savedProfile.maxHp}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: MinecraftTheme.deepStoneCharcoal,
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
                  _HomePanel(
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
                _HomeActionButton(
                  label: 'PLAYER SETUP',
                  icon: Icons.group_add,
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pushNamed(PlayerSetupScreen.routeName);
                  },
                  backgroundColor: MinecraftTheme.darkBrownWood,
                  borderColor: MinecraftTheme.deepStoneCharcoal,
                  textColor: MinecraftTheme.warmCream,
                ),
                const SizedBox(height: 16),
                _HomeActionButton(
                  label: 'START BATTLE',
                  icon: Icons.flash_on,
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

class _HomePanel extends StatelessWidget {
  const _HomePanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MinecraftTheme.warmCream,
        border: Border.all(
          color: MinecraftTheme.deepStoneCharcoal,
          width: MinecraftTheme.chunkBorderWidth,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF2A1D12),
            offset: Offset(6, 6),
            blurRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: child,
    );
  }
}

class _HomeActionButton extends StatefulWidget {
  const _HomeActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  @override
  State<_HomeActionButton> createState() => _HomeActionButtonState();
}

class _HomeActionButtonState extends State<_HomeActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapCancel: () => setState(() => _isPressed = false),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      child: Transform.translate(
        offset: _isPressed ? const Offset(3, 3) : Offset.zero,
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: Border.all(
              color: widget.borderColor,
              width: MinecraftTheme.chunkBorderWidth,
            ),
            boxShadow: _isPressed
                ? []
                : const [
                    BoxShadow(
                      color: Color(0xFF2A1D12),
                      offset: Offset(6, 6),
                      blurRadius: 0,
                    ),
                  ],
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, color: widget.textColor, size: 22),
                const SizedBox(width: 10),
                Text(
                  widget.label,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
