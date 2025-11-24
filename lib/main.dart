import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_state_provider.dart';
import 'pages/login_page.dart';
import 'theme/rpg_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LifeRpgApp());
}

class LifeRpgApp extends StatelessWidget {
  const LifeRpgApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameStateProvider()..initialize(),
      child: MaterialApp(
        title: 'Life RPG',
        debugShowCheckedModeBanner: false,
        theme: RPGTheme.theme,
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final gameState = Provider.of<GameStateProvider>(context, listen: false);
    await gameState.initialize();

    // Navigate to login page
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RPGTheme.darkWood,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              RPGTheme.mediumWood,
              RPGTheme.darkWood,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.castle, size: 120, color: RPGTheme.ornateGold),
              const SizedBox(height: 24),
              MedievalText.title('LIFE RPG'),
              const SizedBox(height: 16),
              MedievalText.body(
                'Loading your adventure...',
                color: RPGTheme.parchment,
              ),
              const SizedBox(height: 32),
              CircularProgressIndicator(color: RPGTheme.ornateGold),
            ],
          ),
        ),
      ),
    );
  }
}
