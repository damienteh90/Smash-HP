import 'package:flutter/material.dart';

import '../models/battle_session.dart';
import '../models/character_avatar.dart';
import '../models/player_profile.dart';
import '../services/battle_logic.dart';
import '../services/local_storage_service.dart';
import '../theme/minecraft_theme.dart';
import '../widgets/hp_bar.dart';
import '../widgets/pixel_button.dart';
import '../widgets/pixel_card.dart';
import 'home_screen.dart';
import 'ko_screen.dart';

class BattleScreen extends StatefulWidget {
  static const String routeName = '/battle';

  const BattleScreen({super.key});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  late PlayerProfile profile;
  late BattleSession session;
  final ScrollController _logScrollController = ScrollController();
  bool _logExpanded = true;
  bool _showHitPose = false;

  @override
  void initState() {
    super.initState();
    _initializeBattle();
  }

  void _initializeBattle() {
    profile = localStorage.getPlayerProfile()!;
    final session = localStorage.getActiveBattleSession();
    if (session != null) {
      this.session = session;
    } else {
      this.session = BattleSession.initial(maxHp: profile.maxHp);
      _saveBattle();
    }
  }

  void _saveBattle() {
    localStorage.saveActiveBattleSession(session);
  }

  @override
  void dispose() {
    _logScrollController.dispose();
    super.dispose();
  }

  void _scrollLogToLatest() {
    if (!_logExpanded) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_logScrollController.hasClients) {
        return;
      }

      _logScrollController.animateTo(
        _logScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _attackMe() async {
    final (newHp, logMessage, damage, wasMiss, wasCritical) =
        BattleLogic.calculateAttack(profile, session);

    session = BattleLogic.applyAttack(session, profile, newHp, logMessage);
    _saveBattle();

    setState(() => _showHitPose = true);
    _scrollLogToLatest();

    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() => _showHitPose = false);
      }
    });

    if (session.isKo) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(KoScreen.routeName);
      }
    }
  }

  void _undo() {
    final previousSession = BattleLogic.undo(session);
    if (previousSession != null) {
      session = previousSession;
      _saveBattle();
      setState(() {});
      _scrollLogToLatest();
    }
  }

  void _newRound() {
    session = BattleLogic.newRound(session);
    _saveBattle();
    setState(() {});
  }

  void _leaveBattle() async {
    await localStorage.clearActiveBattleSession();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _leaveBattle();
        }
      },
      child: Scaffold(
        backgroundColor: MinecraftTheme.warmCream,
        appBar: AppBar(
          title: const Text('BATTLE'),
          elevation: 4,
          backgroundColor: MinecraftTheme.primaryGold,
          foregroundColor: MinecraftTheme.textLight,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: MinecraftTheme.textLight,
            letterSpacing: 1.5,
          ),
          toolbarHeight: 56,
          shape: Border(
            bottom: BorderSide(
              color: MinecraftTheme.deepStoneCharcoal,
              width: MinecraftTheme.chunkBorderWidth,
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
            child: PixelButton(
              label: 'EXIT',
              onPressed: _leaveBattle,
              isPrimary: false,
              backgroundColor: MinecraftTheme.darkBrownWood,
              borderColor: MinecraftTheme.deepStoneCharcoal,
              padding: 4,
            ),
          ),
          leadingWidth: 86,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Player Info Section - Top Card
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                child: PixelCard(
                  borderColor: MinecraftTheme.deepStoneCharcoal,
                  backgroundColor: MinecraftTheme.warmCream,
                  shadowOffset: 4,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Character
                      SizedBox(
                        height: 110,
                        child: CharacterImage(
                          characterId: profile.avatarId,
                          pose: _showHitPose
                              ? CharacterPose.hit
                              : CharacterPose.idle,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Player Name
                      Text(
                        profile.playerName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: MinecraftTheme.textDark,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Round
                      Container(
                        decoration: BoxDecoration(
                          color: MinecraftTheme.warnYellow,
                          border: Border.all(
                            color: MinecraftTheme.deepStoneCharcoal,
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 3,
                        ),
                        child: Text(
                          'ROUND ${session.roundNumber}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: MinecraftTheme.textDark,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // HP Bar
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: MinecraftTheme.deepStoneCharcoal,
                            width: 2,
                          ),
                        ),
                        child: HpBar(
                          currentHp: session.currentHp,
                          maxHp: session.maxHp,
                          height: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // HP Text
                      Text(
                        '${session.currentHp} / ${session.maxHp} HP',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: MinecraftTheme.textDark,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ATTACK ME Button - Very Prominent
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 96,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: MinecraftTheme.battleRed.withValues(
                            alpha: 0.3,
                          ),
                          offset: const Offset(0, 4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: PixelButton(
                      label: 'ATTACK ME!!!',
                      onPressed: _attackMe,
                      isPrimary: true,
                      backgroundColor: MinecraftTheme.battleRed,
                      borderColor: MinecraftTheme.deepStoneCharcoal,
                      padding: 16,
                    ),
                  ),
                ),
              ),
              // Control Buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
                child: SizedBox(
                  height: 48,
                  child: Row(
                    children: [
                      Expanded(
                        child: PixelButton(
                          label: 'UNDO',
                          onPressed: session.undoStack.isNotEmpty
                              ? _undo
                              : () {},
                          isPrimary: false,
                          isDisabled: session.undoStack.isEmpty,
                          backgroundColor: MinecraftTheme.darkBrownWood,
                          borderColor: MinecraftTheme.deepStoneCharcoal,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PixelButton(
                          label: 'NEW ROUND',
                          onPressed: _newRound,
                          isPrimary: false,
                          backgroundColor: MinecraftTheme.primaryGold,
                          borderColor: MinecraftTheme.deepStoneCharcoal,
                          textColor: MinecraftTheme.deepStoneCharcoal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Battle Log - Collapsible Panel
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: MinecraftTheme.deepStoneCharcoal,
                        width: MinecraftTheme.chunkBorderWidth,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: MinecraftTheme.darkBrownWood.withValues(
                            alpha: 0.3,
                          ),
                          offset: const Offset(2, 2),
                          blurRadius: 0,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Header
                        GestureDetector(
                          onTap: () {
                            setState(() => _logExpanded = !_logExpanded);
                            if (_logExpanded) {
                              _scrollLogToLatest();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            color: MinecraftTheme.darkBrownWood,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'BATTLE LOG',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: MinecraftTheme.textLight,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                Icon(
                                  _logExpanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  color: MinecraftTheme.textLight,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Log Content
                        if (_logExpanded)
                          Expanded(
                            child: Container(
                              color: MinecraftTheme.warmCream,
                              padding: const EdgeInsets.all(12),
                              child: session.battleLog.isEmpty
                                  ? Center(
                                      child: Text(
                                        'No battle events yet',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: MinecraftTheme.textDark
                                              .withValues(alpha: 0.5),
                                          fontStyle: FontStyle.italic,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      controller: _logScrollController,
                                      itemCount: session.battleLog.length,
                                      itemBuilder: (context, index) {
                                        final entry = session.battleLog[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 6,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: MinecraftTheme.warmCream,
                                              border: Border.all(
                                                color: MinecraftTheme
                                                    .primaryGold
                                                    .withValues(alpha: 0.3),
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              entry.message,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: MinecraftTheme.textDark,
                                                letterSpacing: 0.2,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          )
                        else
                          Expanded(child: Container()),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
