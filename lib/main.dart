import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';

import 'screens/dashboard/dashboard_screen.dart';
import 'screens/landing/landing_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/register/register_screen.dart';
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

  String _registerError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email ini sudah terdaftar.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'weak-password':
        return 'Password terlalu lemah.';
      case 'operation-not-allowed':
        return 'Registrasi email belum diaktifkan.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti.';
      default:
        return 'Registrasi gagal. ${e.message ?? 'Silakan coba kembali.'}';
    }
  }

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
          icon: const Icon(Icons.arrow_back_rounded),
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
                return 'Login gagal. ${e.message ?? 'Silakan coba kembali.'}';
            }
          } catch (e) {
            return 'Terjadi kesalahan. Silakan coba kembali.';
          }
        },
        onSignedIn: () async {
          final user = _authService.currentUser;

          if (user == null) return;

          Map<String, dynamic>? profil;

          try {
            profil = await FirestoreService().getProfil(user.uid);
          } catch (e) {
            profil = null;
          }

          if (!context.mounted) return;

          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (_) => DashboardScreen(
                nama: profil?['nama'] ?? user.displayName ?? 'Mahasiswa',
                email: profil?['email'] ?? user.email ?? '',
                onLogout: () async {
                  await _authService.logout();

                  if (!context.mounted) return;

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(
                      builder: (_) => const AppEntry(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),
          );
        },
        onRegister: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (registerContext) {
                return RegisterScreen(
                  onRegister: (nama, email, password) async {
                    try {
                      final credential = await _authService.register(
                        email: email,
                        password: password,
                      );

                      final user = credential.user;

                      if (user == null) {
                        return 'Registrasi gagal. Silakan coba kembali.';
                      }

                      await FirestoreService().simpanProfil(
                        uid: user.uid,
                        nama: nama,
                        email: email,
                      );

                      await _authService.logout();

                      return null;
                    } on FirebaseAuthException catch (e) {
                      return _registerError(e);
                    } catch (e) {
                      return 'Akun berhasil dibuat, tetapi profil gagal disimpan. Silakan hubungi pengelola.';
                    }
                  },
                  onBackToLogin: () {
                    Navigator.of(registerContext).pop();
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}