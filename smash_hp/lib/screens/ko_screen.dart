import 'package:flutter/material.dart';

import '../services/app_state.dart';
import '../widgets/primary_action_button.dart';
import 'home_screen.dart';

class KoScreen extends StatelessWidget {
  const KoScreen({super.key});

  static const routeName = '/ko';

  @override
  Widget build(BuildContext context) {
    final knockedOutPlayer = localStorage.battleState.knockedOutPlayer;
    final playerName = knockedOutPlayer?.name ?? 'Player';

    return Scaffold(
      appBar: AppBar(title: const Text('KO')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$playerName is KO\'d',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 32),
            PrimaryActionButton(
              label: 'Back Home',
              onPressed: () {
                localStorage.resetBattle();
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(HomeScreen.routeName, (_) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
