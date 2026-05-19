import 'package:flutter/material.dart';

import '../widgets/primary_action_button.dart';
import 'player_setup_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smash HP')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Track HP until someone gets KO’d.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 32),
            PrimaryActionButton(
              label: 'Start Battle',
              onPressed: () {
                Navigator.of(context).pushNamed(PlayerSetupScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
