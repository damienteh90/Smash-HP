import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'screens/battle_screen.dart';
import 'screens/home_screen.dart';
import 'screens/ko_screen.dart';
import 'screens/player_setup_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'services/local_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await localStorage.initialize();
  await MobileAds.instance.initialize();

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD89A00)),
        useMaterial3: true,
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        PlayerSetupScreen.routeName: (_) => const PlayerSetupScreen(),
        BattleScreen.routeName: (_) => const BattleScreen(),
        KoScreen.routeName: (_) => const KoScreen(),
        SettingsScreen.routeName: (_) => const SettingsScreen(),
      },
    );
  }
}
