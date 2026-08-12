import 'dart:async';

import 'package:scanly/app/scanly_app.dart';
import 'package:scanly/features/auth/repository/auth_failure.dart';
import 'package:scanly/features/auth/repository/auth_repository.dart';
import 'package:scanly/features/auth/repository/auth_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('hiển thị form auth khi chưa đăng nhập', (tester) async {
    final authRepository = FakeAuthRepository();
    addTearDown(authRepository.dispose);

    await tester.pumpWidget(
      ScanlyApp(authRepository: authRepository, locale: const Locale('vi')),
    );
    await tester.pump();

    authRepository.emitUser(null);
    await tester.pumpAndSettle();

    expect(find.text('Scanly'), findsOneWidget);
    expect(find.text('Không gian tài liệu bảo mật của bạn'), findsOneWidget);
    expect(find.byIcon(Icons.mail_outline), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
  });

  testWidgets('đăng nhập bằng email và mật khẩu', (tester) async {
    final authRepository = FakeAuthRepository();
    addTearDown(authRepository.dispose);

    await tester.pumpWidget(
      ScanlyApp(authRepository: authRepository, locale: const Locale('vi')),
    );
    await tester.pump();
    authRepository.emitUser(null);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Email'),
      'user@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Mật khẩu'),
      'secret1',
    );
    await tester.tap(find.byKey(const ValueKey('auth-primary-button')));
    await tester.pumpAndSettle();

    expect(authRepository.lastEmail, 'user@example.com');
    expect(authRepository.lastPassword, 'secret1');
    expect(find.text('Đăng nhập thành công.'), findsOneWidget);
    expect(find.text('Sẵn sàng quét tài liệu'), findsOneWidget);
    expect(find.text('user@example.com'), findsOneWidget);
  });

  testWidgets('hiển thị lỗi khi đăng nhập thất bại', (tester) async {
    final authRepository = FakeAuthRepository()
      ..signInFailureCode = AuthFailureCode.incorrectCredentials;
    addTearDown(authRepository.dispose);

    await tester.pumpWidget(
      ScanlyApp(authRepository: authRepository, locale: const Locale('vi')),
    );
    await tester.pump();
    authRepository.emitUser(null);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Email'),
      'user@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Mật khẩu'),
      'wrong1',
    );
    await tester.tap(find.byKey(const ValueKey('auth-primary-button')));
    await tester.pumpAndSettle();

    expect(find.text('Email hoặc mật khẩu không đúng.'), findsOneWidget);
    expect(find.text('Sẵn sàng quét tài liệu'), findsNothing);
  });

  testWidgets('mở trang đăng ký và tạo tài khoản', (tester) async {
    final authRepository = FakeAuthRepository();
    addTearDown(authRepository.dispose);

    await tester.pumpWidget(
      ScanlyApp(authRepository: authRepository, locale: const Locale('vi')),
    );
    await tester.pump();
    authRepository.emitUser(null);
    await tester.pumpAndSettle();

    final openRegisterButton = find.byKey(
      const ValueKey('open-register-button'),
    );
    await tester.ensureVisible(openRegisterButton);
    await tester.tap(openRegisterButton);
    await tester.pumpAndSettle();

    expect(find.text('Đăng ký'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Nhập lại mật khẩu'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Email'),
      'new@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Mật khẩu'),
      'secret1',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Nhập lại mật khẩu'),
      'secret1',
    );
    await tester.tap(find.byKey(const ValueKey('register-primary-button')));
    await tester.pumpAndSettle();

    expect(authRepository.lastEmail, 'new@example.com');
    expect(authRepository.lastPassword, 'secret1');
    expect(find.text('Tạo tài khoản thành công.'), findsOneWidget);
    expect(find.text('Sẵn sàng quét tài liệu'), findsOneWidget);
    expect(find.text('new@example.com'), findsOneWidget);
  });

  testWidgets('hiển thị lỗi khi đăng ký thất bại', (tester) async {
    final authRepository = FakeAuthRepository()
      ..signUpFailureCode = AuthFailureCode.emailAlreadyInUse;
    addTearDown(authRepository.dispose);

    await tester.pumpWidget(
      ScanlyApp(authRepository: authRepository, locale: const Locale('vi')),
    );
    await tester.pump();
    authRepository.emitUser(null);
    await tester.pumpAndSettle();

    final openRegisterButton = find.byKey(
      const ValueKey('open-register-button'),
    );
    await tester.ensureVisible(openRegisterButton);
    await tester.tap(openRegisterButton);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Email'),
      'used@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Mật khẩu'),
      'secret1',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Nhập lại mật khẩu'),
      'secret1',
    );
    await tester.tap(find.byKey(const ValueKey('register-primary-button')));
    await tester.pumpAndSettle();

    expect(
      find.text('Email này đã được dùng để tạo tài khoản.'),
      findsOneWidget,
    );
    expect(find.text('Sẵn sàng quét tài liệu'), findsNothing);
  });

  testWidgets('chuyển tab bằng bottom bar sau khi đăng nhập', (tester) async {
    final authRepository = FakeAuthRepository();
    addTearDown(authRepository.dispose);

    await tester.pumpWidget(
      ScanlyApp(authRepository: authRepository, locale: const Locale('vi')),
    );
    await tester.pump();
    authRepository.emitUser(
      const AuthUser(id: 'user-1', email: 'user@example.com'),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('bottom-tab-home')), findsOneWidget);
    expect(find.byKey(const ValueKey('bottom-tab-documents')), findsOneWidget);
    expect(find.byKey(const ValueKey('bottom-tab-scan')), findsOneWidget);
    expect(find.byKey(const ValueKey('bottom-tab-tools')), findsOneWidget);
    expect(find.byKey(const ValueKey('bottom-tab-profile')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('bottom-tab-documents')));
    await tester.pumpAndSettle();
    expect(find.text('Chưa có tài liệu'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('bottom-tab-scan')));
    await tester.pumpAndSettle();
    expect(find.text('Bắt đầu quét'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('bottom-tab-tools')));
    await tester.pumpAndSettle();
    expect(
      find.text('Các công cụ xử lý PDF sẽ được gom ở đây để thao tác nhanh.'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('bottom-tab-profile')));
    await tester.pumpAndSettle();
    expect(find.text('Cài đặt'), findsOneWidget);
    expect(find.text('user@example.com'), findsOneWidget);
  });

  testWidgets('hiển thị tiếng Anh theo locale en', (tester) async {
    final authRepository = FakeAuthRepository();
    addTearDown(authRepository.dispose);

    await tester.pumpWidget(
      ScanlyApp(authRepository: authRepository, locale: const Locale('en')),
    );
    await tester.pump();
    authRepository.emitUser(null);
    await tester.pumpAndSettle();

    expect(find.text('Your secure document workspace'), findsOneWidget);
    expect(find.text('Sign in'), findsWidgets);
    expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
  });

  testWidgets('hiển thị tiếng Nhật theo locale ja', (tester) async {
    final authRepository = FakeAuthRepository();
    addTearDown(authRepository.dispose);

    await tester.pumpWidget(
      ScanlyApp(authRepository: authRepository, locale: const Locale('ja')),
    );
    await tester.pump();
    authRepository.emitUser(null);
    await tester.pumpAndSettle();

    expect(find.text('安全なドキュメントワークスペース'), findsOneWidget);
    expect(find.text('ログイン'), findsWidgets);
    expect(find.widgetWithText(TextField, 'パスワード'), findsOneWidget);
  });
}

class FakeAuthRepository implements AuthRepository {
  final _controller = StreamController<AuthUser?>.broadcast();

  String? lastEmail;
  String? lastPassword;
  AuthFailureCode? signInFailureCode;
  AuthFailureCode? signUpFailureCode;
  AuthFailureCode? passwordResetFailureCode;

  @override
  Stream<AuthUser?> get user => _controller.stream;

  @override
  Future<String?> currentIdToken({bool forceRefresh = false}) async {
    return 'fake-token';
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    lastEmail = email;
    if (passwordResetFailureCode case final failureCode?) {
      throw AuthFailure(failureCode);
    }
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    lastEmail = email;
    lastPassword = password;
    if (signInFailureCode case final failureCode?) {
      throw AuthFailure(failureCode);
    }
    emitUser(AuthUser(id: 'user-1', email: email));
  }

  @override
  Future<void> signOut() async {
    emitUser(null);
  }

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    lastEmail = email;
    lastPassword = password;
    if (signUpFailureCode case final failureCode?) {
      throw AuthFailure(failureCode);
    }
    emitUser(AuthUser(id: 'user-1', email: email));
  }

  void emitUser(AuthUser? user) {
    _controller.add(user);
  }

  Future<void> dispose() {
    return _controller.close();
  }
}
