import 'package:flutter/material.dart';

import 'screens/landing/landing_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SILAPOR',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const AppEntry(),
    );
  }
}

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  bool _showProfile = const bool.fromEnvironment(
    'PREVIEW_PROFILE',
    defaultValue: false,
  );

  void _openLogin() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const LoginPage(),
      ),
    );
  }

  void _closeProfilePreview() {
    setState(() {
      _showProfile = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showProfile) {
      return ProfileScreen(
        name: 'Kania Adha Gayatri',
        email: 'kania@student.uns.ac.id',
        roleLabel: 'Mahasiswa',
        preview: true,
        onSignOut: () async {},
        onSignedOut: _closeProfilePreview,
      );
    }

    return LandingScreen(
      onLogin: _openLogin,
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F6FA),
        foregroundColor: const Color(0xFF2B124C),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Kembali ke beranda',
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
        ),
      ),
      body: const LoginScreen(),
    );
  }
}