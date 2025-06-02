import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dewa_wo_app/pages/auth/login/login_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LoginPage Widget Tests', () {
    testWidgets('Login button should trigger form validation', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: LoginPage()),
      );

      final loginButton = find.widgetWithText(ElevatedButton, 'Login');
      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text('Email tidak boleh kosong'), findsOneWidget);
      expect(find.text('Password tidak boleh kosong'), findsOneWidget);
    });

    testWidgets('Form validation blocks invalid email and short password', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: LoginPage()),
      );

      final emailField = find.byType(TextFormField).at(0);
      final passwordField = find.byType(TextFormField).at(1);
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');

      await tester.enterText(emailField, 'invalid-email');
      await tester.enterText(passwordField, '123');
      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text('Masukkan email yang valid'), findsOneWidget);
      expect(find.text('Password minimal 6 karakter'), findsOneWidget);
    });

    testWidgets('Password visibility toggle works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: LoginPage()),
      );

      // Awalnya ikon visibility_off muncul
      final visibilityOffIcon = find.byIcon(Icons.visibility_off);
      expect(visibilityOffIcon, findsOneWidget);

      // Tap untuk toggle
      await tester.tap(visibilityOffIcon);
      await tester.pump();

      // Setelah toggle, ikon berubah jadi visibility
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('Show CircularProgressIndicator while logging in', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(builder: (context) {
            return const LoginPage();
          }),
        ),
      );

      // Ambil elemen LoginPage dan ubah isLoading secara manual
      final state = tester.state(find.byType(LoginPage)) as dynamic;
      state.setState(() {
        state.isLoading = true;
      });

      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Login button is disabled while loading', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      final state = tester.state(find.byType(LoginPage)) as dynamic;
      state.setState(() {
        state.isLoading = true;
      });

      await tester.pump();
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');
      final ElevatedButton button = tester.widget(loginButton);
      expect(button.onPressed, isNull);
    });

    testWidgets('Error message is displayed when authentication fails', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      final state = tester.state(find.byType(LoginPage)) as dynamic;
      state.setState(() {
        state.errorMessage = 'Email atau password salah';
      });

      await tester.pump();
      expect(find.text('Email atau password salah'), findsOneWidget);
    });
  });
}
