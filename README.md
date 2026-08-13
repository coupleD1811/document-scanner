# Scanly

Scanly biến điện thoại thành công cụ scan, lưu trữ và xử lý tài liệu cá nhân.

## Trạng Thái Hiện Tại

Project hiện đang ở giai đoạn nền tảng ban đầu. Phần đã có:

- Đăng nhập bằng Firebase Auth với Email/Mật khẩu.
- Đăng ký tài khoản, đăng xuất và đặt lại mật khẩu.
- Thông báo trạng thái đăng nhập/đăng ký bằng snackbar.
- Quản lý auth bằng BLoC.
- Tách auth repository khỏi Firebase implementation.
- Có sẵn `currentIdToken()` để gửi Firebase ID token lên backend.
- Hỗ trợ đa ngôn ngữ: tiếng Việt, tiếng Anh và tiếng Nhật.
- Giao diện chính sau đăng nhập với bottom bar 5 tab.
- Cho phép đổi và lưu ngôn ngữ trong tab Cá nhân.

Các phần scanner, OCR, PDF toolkit, cloud upload, IAP và backend riêng chưa
được triển khai trong phiên bản hiện tại.

## Tech Stack

- Flutter
- Firebase Core
- Firebase Authentication
- Flutter BLoC
- Flutter `gen-l10n`

## Cấu Trúc Auth

```text
lib/features/auth/
  login/
    bloc/        # LoginBloc: đăng nhập, quên mật khẩu
    login_page.dart
  register/
    bloc/        # RegisterBloc: tạo tài khoản
    register_page.dart
  session/
    bloc/        # AuthSessionBloc: session chung, đăng xuất
  repository/    # contract auth, model user, lỗi auth, Firebase implementation
  presentation/  # AuthGate và widget UI dùng chung trong auth
```

Quy ước hiện tại: mỗi feature lớn sẽ có BLoC riêng cho flow của nó. BLoC cấp
cao hơn chỉ giữ trạng thái dùng chung, ví dụ `AuthSessionBloc` chỉ quản lý
session, không xử lý form đăng nhập hoặc đăng ký.

## Cấu Trúc Feature

Các tab chính đã được tách thành feature riêng để dễ mở rộng:

```text
lib/features/
  main_navigation/  # shell sau đăng nhập, app bar và bottom bar
  home/             # tab Trang chủ
  documents/        # tab Tài liệu
  scan/             # tab Quét
  tools/            # tab Công cụ
  profile/          # tab Cá nhân và chọn ngôn ngữ
  shared/widgets/   # widget nhỏ dùng chung giữa các feature
```

`auth` chỉ chịu trách nhiệm xác thực và session. Nội dung sau khi đăng nhập
nằm ở `main_navigation` và từng feature tab riêng.

## Navigation Chính

Sau khi đăng nhập, app dùng bottom bar 5 tab:

```text
Trang chủ | Tài liệu | Quét | Công cụ | Cá nhân
```

Quy ước hiện tại:

- Dùng `CupertinoIcons` cho các tab chính.
- Nút `Quét` nằm giữa và nổi bật hơn các tab còn lại.
- Icon quét chính: `CupertinoIcons.doc_text_viewfinder`.

## Đa Ngôn Ngữ

Project dùng localization chuẩn của Flutter với `gen-l10n`.

```text
lib/l10n/
  app_vi.arb   # tiếng Việt
  app_en.arb   # tiếng Anh
  app_ja.arb   # tiếng Nhật
  generated/   # file Dart được generate từ ARB
  l10n.dart    # extension context.l10n
```

Sau khi thêm hoặc sửa key trong các file `.arb`, chạy:

```sh
flutter gen-l10n
```

App mặc định dùng tiếng Việt. Người dùng có thể đổi ngôn ngữ trong tab
`Cá nhân > Ngôn ngữ`; lựa chọn này được lưu lại trên thiết bị.

## Cấu Hình Firebase

Tạo Firebase project, thêm app iOS/Android, rồi bật Email/Password trong
Firebase Authentication.

```sh
dart pub global activate flutterfire_cli
flutterfire configure \
  --project=<firebase-project-id-cua-ban> \
  --platforms=android,ios \
  --android-package-name=com.scanly.app \
  --ios-bundle-id=com.scanly.app \
  --out=lib/firebase_options.dart
flutter run
```

Sau khi chạy `flutterfire configure`, app sẽ có các file cấu hình:

```text
lib/firebase_options.dart
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
```

`lib/main.dart` cần khởi tạo Firebase bằng options đã generate:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

Định danh app hiện tại:

- Android package name: `com.scanly.app`
- iOS bundle id: `com.scanly.app`

## Kết Nối Backend

Flutter app sẽ gửi Firebase ID token trong mỗi request cần xác thực:

```http
Authorization: Bearer <firebase-id-token>
```

Backend Node.js sẽ dùng Firebase Admin SDK để verify token đó, sau đó map
Firebase `uid` với user trong database riêng của Scanly.

## Kiểm Tra

```sh
flutter gen-l10n
flutter analyze
flutter test
```
