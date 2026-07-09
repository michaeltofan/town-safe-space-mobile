import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

class TownApp extends StatelessWidget {
  const TownApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TOWN',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const WelcomeScreen(),
    );
  }
}
