import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/battle_screen.dart';
import 'screens/home_screen.dart';
import 'screens/ko_screen.dart';
import 'screens/player_setup_screen.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const SmashHpApp());
}

class SmashHpApp extends StatelessWidget {
  const SmashHpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smash HP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        PlayerSetupScreen.routeName: (_) => const PlayerSetupScreen(),
        BattleScreen.routeName: (_) => const BattleScreen(),
        KoScreen.routeName: (_) => const KoScreen(),
      },
    );
  }
}
