import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:silapor/screens/login/login_screen.dart';
import 'package:silapor/screens/profile/profile_screen.dart';
import 'package:silapor/utils/app_theme.dart';

void main() {
  testWidgets(
    'Login kosong menampilkan pesan validasi',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildAppTheme(),
          home: const LoginScreen(),
        ),
      );

      final loginButton = find.widgetWithText(
        FilledButton,
        'Masuk',
      );

      await tester.ensureVisible(loginButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(
        find.text('Email wajib diisi.'),
        findsOneWidget,
      );

      expect(
        find.text('Password wajib diisi.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Keluar hanya diproses setelah dikonfirmasi',
    (tester) async {
      var signOutCalls = 0;
      var signedOutCalls = 0;

      await tester.pumpWidget(
        MaterialApp(
          theme: buildAppTheme(),
          home: ProfileScreen(
            name: 'Kania Adha Gayatri',
            email: 'kania@student.uns.ac.id',
            roleLabel: 'Mahasiswa',
            onSignOut: () async {
              signOutCalls++;
            },
            onSignedOut: () {
              signedOutCalls++;
            },
          ),
        ),
      );

      final logoutButton = find.widgetWithText(
        FilledButton,
        'Keluar dari akun',
      );

      await tester.ensureVisible(logoutButton);
      await tester.tap(logoutButton);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();

      expect(signOutCalls, 0);
      expect(signedOutCalls, 0);

      await tester.tap(logoutButton);
      await tester.pumpAndSettle();

      await tester.tap(
        find.widgetWithText(FilledButton, 'Keluar'),
      );
      await tester.pumpAndSettle();

      expect(signOutCalls, 1);
      expect(signedOutCalls, 1);
    },
  );
}