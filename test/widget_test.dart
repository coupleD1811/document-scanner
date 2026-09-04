import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanly/app/scanly_app.dart';
import 'package:scanly/app/theme/scanly_icons.dart';
import 'package:scanly/features/auth/repository/auth_failure.dart';
import 'package:scanly/features/auth/repository/auth_repository.dart';
import 'package:scanly/features/auth/repository/auth_user.dart';
import 'package:scanly/features/documents/model/model.dart';
import 'package:scanly/features/documents/service/document_file_picker.dart';
import 'package:scanly/features/documents/view/page.dart';
import 'package:scanly/features/scan/bloc/scan_session_bloc.dart';
import 'package:scanly/features/scan/model/document_corners.dart';
import 'package:scanly/features/scan/model/normalized_document_image.dart';
import 'package:scanly/features/scan/service/camera_access_service.dart';
import 'package:scanly/features/scan/view/scan_camera_page.dart';
import 'package:scanly/features/scan/view/scan_editor_page.dart';
import 'package:scanly/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('hiển thị form auth khi chưa đăng nhập', (tester) async {
    final authRepository = FakeAuthRepository();
    addTearDown(authRepository.dispose);

    await tester.pumpWidget(
      ScanlyApp(authRepository: authRepository, locale: const Locale('vi')),
    );
    await tester.pump();

    authRepository.emitUser(null);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('auth-brand-logo')), findsOneWidget);
    expect(find.text('Không gian tài liệu bảo mật của bạn'), findsOneWidget);
    expect(find.byIcon(LucideIcons.mail), findsOneWidget);
    expect(find.byIcon(LucideIcons.lockKeyhole), findsOneWidget);
    expect(find.text('Tiếp tục với Google'), findsOneWidget);
    expect(find.text('Tiếp tục với Facebook'), findsOneWidget);

    final googleIcon = find.image(
      const AssetImage('images/logo/google_icon.png'),
    );
    final facebookIcon = find.image(
      const AssetImage('images/logo/facebook_icon.png'),
    );
    expect(
      tester.getCenter(googleIcon).dx,
      closeTo(tester.getCenter(facebookIcon).dx, 0.1),
    );
    expect(
      tester.getSize(googleIcon).height,
      tester.getSize(facebookIcon).height,
    );
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
    expect(find.text('Chào mừng trở lại, user'), findsOneWidget);
    expect(find.text('Quét tài liệu'), findsOneWidget);
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
    expect(find.text('Quét tài liệu'), findsNothing);
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

    expect(find.text('Tạo tài khoản'), findsWidgets);
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
    expect(find.text('Chào mừng trở lại, new'), findsOneWidget);
    expect(find.text('Quét tài liệu'), findsOneWidget);
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
    expect(find.text('Quét tài liệu'), findsNothing);
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
    expect(find.byIcon(ScanlyIcons.imageToPdf), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('bottom-tab-documents')));
    await tester.pumpAndSettle();
    expect(find.text('Chưa có tài liệu'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('documents-search-field')),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      find.text('Sắp ra mắt'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Sắp ra mắt'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('bottom-tab-tools')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('tools-brand-logo')), findsOneWidget);
    expect(find.text('Công cụ PDF'), findsOneWidget);
    expect(find.text('Chỉnh sửa và sắp xếp'), findsOneWidget);
    expect(find.byKey(const ValueKey('tool-merge-pdf')), findsOneWidget);
    expect(find.byIcon(ScanlyIcons.imageToPdf), findsOneWidget);
    expect(find.byIcon(ScanlyIcons.ocrText), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('tool-merge-pdf')));
    await tester.pump();
    expect(
      find.text('Công cụ này sẽ được bổ sung trong phiên bản tiếp theo.'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('bottom-tab-profile')));
    await tester.pumpAndSettle();
    expect(find.text('Giao diện'), findsOneWidget);
    expect(find.text('user@example.com'), findsOneWidget);
  });

  testWidgets('hiển thị và lọc danh sách tài liệu', (tester) async {
    final documents = [
      DocumentItem(
        id: 'pdf-1',
        name: 'Employment Contract.pdf',
        type: DocumentType.pdf,
        updatedAt: DateTime(2026, 8, 20),
        pageCount: 4,
        sizeInBytes: 1258291,
        hasOcrText: true,
      ),
      DocumentItem(
        id: 'scan-1',
        name: 'Receipt 15-08-2026.pdf',
        type: DocumentType.scan,
        updatedAt: DateTime(2026, 8, 15),
        pageCount: 1,
        sizeInBytes: 215040,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('vi'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: DocumentsPage(documents: documents)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('2 tài liệu'), findsOneWidget);
    expect(find.text('Employment Contract.pdf'), findsOneWidget);
    expect(find.byIcon(ScanlyIcons.importPdf), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('documents-filter-scans')));
    await tester.pumpAndSettle();

    expect(find.text('1 tài liệu'), findsOneWidget);
    expect(find.text('Employment Contract.pdf'), findsNothing);
    expect(find.text('Receipt 15-08-2026.pdf'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('document-more-scan-1')));
    await tester.pumpAndSettle();

    expect(find.text('Mở'), findsOneWidget);
    expect(find.text('Đổi tên'), findsOneWidget);
    expect(find.text('Chia sẻ'), findsOneWidget);
    expect(find.text('Di chuyển'), findsOneWidget);
    expect(find.text('Xóa'), findsOneWidget);
  });

  testWidgets('chỉ mở trình chọn PDF khi người dùng nhấn nhập tệp', (
    tester,
  ) async {
    final filePicker = FakeDocumentFilePicker(
      selectedFile: XFile('/tmp/contract.pdf'),
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('vi'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: DocumentsPage(filePicker: filePicker)),
      ),
    );
    await tester.pumpAndSettle();

    expect(filePicker.pickCount, 0);

    await tester.tap(find.byKey(const ValueKey('documents-import-button')));
    await tester.pumpAndSettle();

    expect(filePicker.pickCount, 1);
    expect(find.text('Đã chọn contract.pdf.'), findsOneWidget);
  });

  testWidgets('xin quyền camera khi màn quét được mở', (tester) async {
    final cameraAccessService = FakeCameraAccessService();

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('vi'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ScanCameraPage(cameraAccessService: cameraAccessService),
      ),
    );
    await tester.pumpAndSettle();

    expect(cameraAccessService.permissionRequestCount, 1);
    expect(cameraAccessService.initializeCount, 1);
    expect(find.byKey(const ValueKey('camera-capture-button')), findsOneWidget);
  });

  testWidgets('hiển thị cách xử lý khi quyền camera bị từ chối', (
    tester,
  ) async {
    final cameraAccessService = FakeCameraAccessService(
      permissionOutcome: CameraPermissionOutcome.permanentlyDenied,
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('vi'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ScanCameraPage(cameraAccessService: cameraAccessService),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Quyền camera đang bị tắt'), findsOneWidget);
    expect(find.text('Mở Cài đặt'), findsOneWidget);

    await tester.tap(find.text('Mở Cài đặt'));
    await tester.pump();

    expect(cameraAccessService.openSettingsCount, 1);
  });

  testWidgets('editor hiển thị và xóa trang trong phiên quét', (tester) async {
    final sessionBloc = ScanSessionBloc();
    addTearDown(sessionBloc.close);
    final firstPageState = sessionBloc.stream.firstWhere(
      (state) => state.session?.pages.length == 1,
    );
    sessionBloc.add(ScanSessionPageAdded(_normalizedImage(1)));
    await firstPageState;
    final secondPageState = sessionBloc.stream.firstWhere(
      (state) => state.session?.pages.length == 2,
    );
    sessionBloc.add(ScanSessionPageAdded(_normalizedImage(2)));
    await secondPageState;

    await tester.pumpWidget(
      BlocProvider.value(
        value: sessionBloc,
        child: MaterialApp(
          locale: const Locale('vi'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ScanEditorPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Kiểm tra bản quét'), findsOneWidget);
    expect(find.text('Trang 2 / 2'), findsOneWidget);
    expect(find.byKey(const ValueKey('scan-editor-add-page')), findsOneWidget);
    expect(find.byKey(const ValueKey('scan-editor-continue')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('scan-editor-delete-page')));
    await tester.pumpAndSettle();

    expect(find.text('Trang 1 / 1'), findsOneWidget);
    expect(sessionBloc.state.session!.pages, hasLength(1));

    await tester.tap(find.byKey(const ValueKey('scan-editor-adjust-corners')));
    await tester.pumpAndSettle();

    expect(find.text('Chỉnh các góc'), findsOneWidget);
    expect(find.byKey(const ValueKey('scan-corner-topLeft')), findsOneWidget);

    await tester.drag(
      find.byKey(const ValueKey('scan-corner-topLeft')),
      const Offset(18, 24),
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('scan-corners-save')));
    await tester.pumpAndSettle();

    expect(
      sessionBloc.state.session!.pages.single.corners.source,
      DocumentCornersSource.manual,
    );
    expect(find.text('Đã chỉnh các góc tài liệu'), findsOneWidget);
  });

  testWidgets('đổi ngôn ngữ trong tab cá nhân', (tester) async {
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

    await tester.tap(find.byKey(const ValueKey('bottom-tab-profile')));
    await tester.pumpAndSettle();

    expect(find.text('Ngôn ngữ'), findsWidgets);
    expect(
      find.byKey(const ValueKey('current-language-icon-vi')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('language-setting-tile')));
    await tester.pumpAndSettle();
    expect(find.text('Chọn ngôn ngữ'), findsOneWidget);
    expect(find.text('Tiếng Việt'), findsWidgets);
    expect(
      find.byKey(const ValueKey('language-option-icon-vi')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('language-option-icon-en')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('language-option-icon-ja')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('language-option-en')));
    await tester.pumpAndSettle();

    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Language'), findsWidgets);
    expect(
      find.byKey(const ValueKey('current-language-icon-en')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('language-setting-tile')));
    await tester.pumpAndSettle();
    expect(find.text('English'), findsWidgets);
    await tester.tap(find.byKey(const ValueKey('language-option-ja')));
    await tester.pumpAndSettle();

    expect(find.text('外観'), findsOneWidget);
    expect(find.text('言語'), findsWidgets);
    expect(
      find.byKey(const ValueKey('current-language-icon-ja')),
      findsOneWidget,
    );

    await tester.pumpWidget(const SizedBox.shrink());

    final restoredAuthRepository = FakeAuthRepository();
    addTearDown(restoredAuthRepository.dispose);

    await tester.pumpWidget(
      ScanlyApp(
        authRepository: restoredAuthRepository,
        locale: const Locale('vi'),
      ),
    );
    await tester.pump();
    restoredAuthRepository.emitUser(null);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('安全なドキュメントワークスペース'), findsOneWidget);
    expect(find.text('ログイン'), findsWidgets);
  });

  testWidgets('đổi và ghi nhớ chế độ sáng tối', (tester) async {
    final authRepository = FakeAuthRepository();
    addTearDown(authRepository.dispose);

    await tester.pumpWidget(
      ScanlyApp(authRepository: authRepository, locale: const Locale('vi')),
    );
    await tester.pump();
    authRepository.emitUser(
      const AuthUser(id: 'user-1', email: 'asd@gmail.com'),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('bottom-tab-profile')));
    await tester.pumpAndSettle();

    expect(find.text('asd'), findsOneWidget);
    expect(find.text('Sáng'), findsOneWidget);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );

    await tester.tap(find.byKey(const ValueKey('theme-mode-switch')));
    await tester.pumpAndSettle();

    expect(find.text('Tối'), findsOneWidget);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );

    await tester.pumpWidget(const SizedBox.shrink());

    final restoredAuthRepository = FakeAuthRepository();
    addTearDown(restoredAuthRepository.dispose);
    await tester.pumpWidget(
      ScanlyApp(
        authRepository: restoredAuthRepository,
        locale: const Locale('vi'),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    restoredAuthRepository.emitUser(
      const AuthUser(id: 'user-2', email: 'asd@gmail.com'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('bottom-tab-profile')));
    await tester.pumpAndSettle();

    expect(find.text('Tối'), findsOneWidget);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
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

NormalizedDocumentImage _normalizedImage(int pageNumber) {
  return NormalizedDocumentImage(
    originalImagePath: '/tmp/page-$pageNumber.jpg',
    normalizedImagePath: '/tmp/page-$pageNumber-normalized.jpg',
    pixelWidth: 1200,
    pixelHeight: 1600,
  );
}

class FakeDocumentFilePicker implements DocumentFilePicker {
  FakeDocumentFilePicker({this.selectedFile});

  final XFile? selectedFile;
  int pickCount = 0;

  @override
  Future<XFile?> pickPdf() async {
    pickCount += 1;
    return selectedFile;
  }
}

class FakeCameraAccessService implements CameraAccessService {
  FakeCameraAccessService({
    this.permissionOutcome = CameraPermissionOutcome.granted,
  });

  CameraPermissionOutcome permissionOutcome;
  int permissionRequestCount = 0;
  int initializeCount = 0;
  int openSettingsCount = 0;

  @override
  CameraController? get controller => null;

  @override
  Future<String> capture() async => '/tmp/scan.jpg';

  @override
  Future<void> disposeCamera() async {}

  @override
  Future<void> initializeCamera() async {
    initializeCount += 1;
  }

  @override
  Future<bool> openSettings() async {
    openSettingsCount += 1;
    return true;
  }

  @override
  Future<CameraPermissionOutcome> requestPermission() async {
    permissionRequestCount += 1;
    return permissionOutcome;
  }
}
