import 'package:bloc/bloc.dart';
import 'package:dewa_wo_app/core/di/dependency_injection.dart';
import 'package:dewa_wo_app/pages/auth/cubit/auth_cubit.dart';
import 'package:dewa_wo_app/pages/auth/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthCubit extends Cubit<AuthState> implements AuthCubit {
  FakeAuthCubit() : super(const AuthState.initial());

  void emitState(AuthState newState) => emit(newState);

  @override
  Future<void> checkAuthStatus() async {}

  @override
  Future<void> login({required String email, required String password}) async {}

  @override
  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {}

  @override
  Future<void> logout() async {}

  @override
  Future<void> refreshUserData() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeAuthCubit authCubit;

  setUp(() {
    authCubit = FakeAuthCubit();
    getIt.registerSingleton<AuthCubit>(authCubit);
  });

  tearDown(() async {
    await getIt.reset();
  });

  Future<void> pumpLoginPage(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
  }

  group('LoginPage Widget Tests', () {
    testWidgets('Login button should trigger form validation', (WidgetTester tester) async {
      await pumpLoginPage(tester);

      final loginButton = find.widgetWithText(ElevatedButton, 'Login');
      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text('Email tidak boleh kosong'), findsOneWidget);
      expect(find.text('Password tidak boleh kosong'), findsOneWidget);
    });

    testWidgets('Form validation blocks invalid email and short password', (WidgetTester tester) async {
      await pumpLoginPage(tester);

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
      await pumpLoginPage(tester);

      final visibilityOffIcon = find.byIcon(Icons.visibility_off);
      expect(visibilityOffIcon, findsOneWidget);

      await tester.tap(visibilityOffIcon);
      await tester.pump();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('Show CircularProgressIndicator while logging in', (WidgetTester tester) async {
      await pumpLoginPage(tester);

      authCubit.emitState(const AuthState.loading());
      await tester.pump();

      // Button spinner plus the full-screen loading overlay.
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('Login button is disabled while loading', (WidgetTester tester) async {
      await pumpLoginPage(tester);

      authCubit.emitState(const AuthState.loading());
      await tester.pump();

      // While loading the button label is replaced by a spinner, so find by type.
      final ElevatedButton button = tester.widget(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('Error message is displayed when authentication fails', (WidgetTester tester) async {
      await pumpLoginPage(tester);

      authCubit.emitState(const AuthState.error(message: 'Email atau password salah'));
      await tester.pump();

      expect(find.text('Email atau password salah'), findsOneWidget);
    });
  });
}
