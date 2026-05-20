import 'package:flutter/material.dart';

import '../services/local_storage_service.dart';
import '../theme/minecraft_theme.dart';
import '../widgets/pixel_button.dart';
import 'home_screen.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _soundEnabled;
  late bool _vibrationEnabled;

  @override
  void initState() {
    super.initState();
    _soundEnabled = localStorage.isSoundEnabled();
    _vibrationEnabled = localStorage.isVibrationEnabled();
  }

  Future<void> _setSoundEnabled(bool enabled) async {
    await localStorage.setSoundEnabled(enabled);
    if (mounted) {
      setState(() => _soundEnabled = enabled);
    }
  }

  Future<void> _setVibrationEnabled(bool enabled) async {
    await localStorage.setVibrationEnabled(enabled);
    if (mounted) {
      setState(() => _vibrationEnabled = enabled);
    }
  }

  Future<void> _confirmResetProfile() async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: MinecraftTheme.warmCream,
          title: const Text(
            'RESET PROFILE?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: MinecraftTheme.deepStoneCharcoal,
            ),
          ),
          content: const Text(
            'This will delete your saved profile and active battle.',
            style: TextStyle(color: MinecraftTheme.deepStoneCharcoal),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'RESET',
                style: TextStyle(color: MinecraftTheme.battleRed),
              ),
            ),
          ],
        );
      },
    );

    if (shouldReset != true) {
      return;
    }

    await localStorage.clearPlayerProfile();
    await localStorage.clearActiveBattleSession();

    if (mounted) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(HomeScreen.routeName, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MinecraftTheme.warmCream,
      appBar: AppBar(
        title: const Text('SETTINGS'),
        elevation: 0,
        backgroundColor: MinecraftTheme.primaryGold,
        foregroundColor: MinecraftTheme.deepStoneCharcoal,
        centerTitle: true,
        titleTextStyle: const TextStyle(
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
              _SettingsPanel(
                child: Column(
                  children: [
                    _SettingsToggleRow(
                      label: 'SOUND',
                      value: _soundEnabled,
                      onChanged: _setSoundEnabled,
                    ),
                    const SizedBox(height: 12),
                    _SettingsToggleRow(
                      label: 'VIBRATION',
                      value: _vibrationEnabled,
                      onChanged: _setVibrationEnabled,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 54,
                child: PixelButton(
                  label: 'RESET SAVED PROFILE',
                  onPressed: _confirmResetProfile,
                  backgroundColor: MinecraftTheme.battleRed,
                  borderColor: MinecraftTheme.deepStoneCharcoal,
                  padding: 10,
                ),
              ),
              const SizedBox(height: 20),
              _SettingsPanel(
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ABOUT SMASH HP',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: MinecraftTheme.primaryGold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Smash HP turns your phone into a physical game health bar. Set your HP, let friends attack your phone, and survive the battle.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: MinecraftTheme.deepStoneCharcoal,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel({required this.child});

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
            offset: Offset(5, 5),
            blurRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}

class _SettingsToggleRow extends StatelessWidget {
  const _SettingsToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MinecraftTheme.darkBrownWood,
        border: Border.all(color: MinecraftTheme.deepStoneCharcoal, width: 3),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: MinecraftTheme.warmCream,
                letterSpacing: 1.0,
              ),
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: MinecraftTheme.hpGreen,
            activeTrackColor: MinecraftTheme.hpGreen.withValues(alpha: 0.35),
            inactiveThumbColor: MinecraftTheme.primaryGold,
            inactiveTrackColor: MinecraftTheme.deepStoneCharcoal.withValues(
              alpha: 0.45,
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
