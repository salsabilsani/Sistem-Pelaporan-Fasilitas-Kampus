import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'services/auth_service.dart';

import 'screens/landing/landing_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        builder: (_) => LoginPage(),
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
  LoginPage({super.key});

  final AuthService _authService = AuthService();

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
      body: LoginScreen(
        onSignIn: (email, password) async {
          try {
            await _authService.login(
              email: email,
              password: password,
            );

            return null;
          } on FirebaseAuthException catch (e) {
            switch (e.code) {
              case 'user-not-found':
                return 'Email belum terdaftar.';
              case 'wrong-password':
                return 'Password yang kamu masukkan salah.';
              case 'invalid-credential':
                return 'Email atau password salah.';
              case 'invalid-email':
                return 'Format email tidak valid.';
              case 'user-disabled':
                return 'Akun ini telah dinonaktifkan.';
              case 'too-many-requests':
                return 'Terlalu banyak percobaan. Coba lagi nanti.';
              default:
                return 'Login gagal. ${e.message ?? 'Silakan coba lagi.'}';
            }
          } catch (e) {
            return 'Terjadi kesalahan. Silakan coba kembali.';
          }
        },
        onSignedIn: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login Firebase berhasil!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }
}
