import 'package:flutter/material.dart';

import '../models/battle_state.dart';
import '../models/player.dart';
import '../widgets/primary_action_button.dart';
import '../services/app_state.dart';
import 'battle_screen.dart';

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  static const routeName = '/player-setup';

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  final _playerOneController = TextEditingController(text: 'Player 1');
  final _playerTwoController = TextEditingController(text: 'Player 2');
  int _startingHp = 100;

  @override
  void dispose() {
    _playerOneController.dispose();
    _playerTwoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Player Setup')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(
            controller: _playerOneController,
            decoration: const InputDecoration(labelText: 'Player 1'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _playerTwoController,
            decoration: const InputDecoration(labelText: 'Player 2'),
          ),
          const SizedBox(height: 24),
          Text('Starting HP: $_startingHp'),
          Slider(
            value: _startingHp.toDouble(),
            min: 10,
            max: 300,
            divisions: 29,
            label: _startingHp.toString(),
            onChanged: (value) {
              setState(() {
                _startingHp = value.round();
              });
            },
          ),
          const SizedBox(height: 24),
          PrimaryActionButton(label: 'Begin', onPressed: _saveAndStartBattle),
        ],
      ),
    );
  }

  void _saveAndStartBattle() {
    localStorage.saveBattleState(
      BattleState(
        startingHp: _startingHp,
        players: [
          Player(name: _playerOneController.text.trim(), hp: _startingHp),
          Player(name: _playerTwoController.text.trim(), hp: _startingHp),
        ],
      ),
    );

    Navigator.of(context).pushReplacementNamed(BattleScreen.routeName);
  }
}
