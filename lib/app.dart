import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/home_screen.dart';

class KisanChainApp extends StatelessWidget {
  const KisanChainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KisanChain',
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}