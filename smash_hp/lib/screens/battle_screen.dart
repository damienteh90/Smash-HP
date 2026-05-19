import 'package:flutter/material.dart';

import '../models/battle_state.dart';
import '../services/app_state.dart';
import 'ko_screen.dart';

class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  static const routeName = '/battle';

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  late BattleState _battleState;

  @override
  void initState() {
    super.initState();
    _battleState = localStorage.battleState;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Battle')),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: _battleState.players.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final player = _battleState.players[index];

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name.isEmpty ? 'Player ${index + 1}' : player.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${player.hp} HP',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _damagePlayer(index, 10),
                          child: const Text('-10'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _damagePlayer(index, 25),
                          child: const Text('-25'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _damagePlayer(int index, int amount) {
    setState(() {
      _battleState = _battleState.damagePlayer(index, amount);
      localStorage.saveBattleState(_battleState);
    });

    if (_battleState.hasKo) {
      Navigator.of(context).pushReplacementNamed(KoScreen.routeName);
    }
  }
}
