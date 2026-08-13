// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Scanly';

  @override
  String get firebaseNotConfiguredTitle => 'Firebase が未設定です';

  @override
  String get firebaseNotConfiguredBody =>
      'Firebase プロジェクトを作成し、メール/パスワードログインを有効にしてから、このアプリの FlutterFire 設定を実行してください。';

  @override
  String get startupErrorTitle => '起動エラー';

  @override
  String get secureWorkspaceTagline => '安全なドキュメントワークスペース';

  @override
  String get loginTitle => 'ログイン';

  @override
  String get loginSubtitle => 'Scanly でドキュメント管理を続けます。';

  @override
  String get emailLabel => 'メール';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get passwordLabel => 'パスワード';

  @override
  String get showPasswordTooltip => 'パスワードを表示';

  @override
  String get hidePasswordTooltip => 'パスワードを非表示';

  @override
  String get loginAction => 'ログイン';

  @override
  String get forgotPasswordAction => 'パスワードを忘れた場合';

  @override
  String get createNewAccountAction => '新しいアカウントを作成';

  @override
  String get authBackendNote =>
      '認証には Firebase を使用します。Node.js API は各リクエストの Firebase ID トークンを検証できます。';

  @override
  String get registerTitle => '登録';

  @override
  String get createAccountTitle => 'アカウント作成';

  @override
  String get registerSubtitle => 'Scanly アカウントを作成して、ドキュメントの保存と管理を始めましょう。';

  @override
  String get confirmPasswordLabel => 'パスワードを再入力';

  @override
  String get createAccountAction => 'アカウントを作成';

  @override
  String get emailRequired => 'メールを入力してください。';

  @override
  String get emailInvalid => '有効なメールを入力してください。';

  @override
  String get passwordRequired => 'パスワードを入力してください。';

  @override
  String get passwordMinLength => 'パスワードは6文字以上にしてください。';

  @override
  String get confirmPasswordRequired => 'パスワードを再入力してください。';

  @override
  String get confirmPasswordMismatch => 'パスワードが一致しません。';

  @override
  String get signInSuccess => 'ログインしました。';

  @override
  String get accountCreatedSuccess => 'アカウントを作成しました。';

  @override
  String get passwordResetEmailSent => 'パスワード再設定メールを送信しました。';

  @override
  String get signInFailed => 'ログインに失敗しました。もう一度お試しください。';

  @override
  String get accountCreationFailed => 'アカウント作成に失敗しました。もう一度お試しください。';

  @override
  String get passwordResetFailed => 'パスワード再設定メールを送信できませんでした。もう一度お試しください。';

  @override
  String get signOutFailed => 'ログアウトに失敗しました。もう一度お試しください。';

  @override
  String get invalidEmail => '有効なメールを入力してください。';

  @override
  String get incorrectCredentials => 'メールまたはパスワードが正しくありません。';

  @override
  String get emailAlreadyInUse => 'このメールはすでにアカウントで使用されています。';

  @override
  String get weakPassword => '6文字以上のより強いパスワードを使用してください。';

  @override
  String get userDisabled => 'このアカウントは無効化されています。';

  @override
  String get emailPasswordNotEnabled => 'Firebase でメール/パスワードログインが有効になっていません。';

  @override
  String get tooManyRequests => '試行回数が多すぎます。少し待ってから再試行してください。';

  @override
  String get networkRequestFailed => 'ネットワークエラーです。接続を確認して再試行してください。';

  @override
  String get authenticationFailed => '認証に失敗しました。';

  @override
  String get sessionRestoreFailed => 'ログインセッションを復元できませんでした。';

  @override
  String get tabHome => 'ホーム';

  @override
  String get tabDocuments => '書類';

  @override
  String get tabScan => 'スキャン';

  @override
  String get tabTools => 'ツール';

  @override
  String get tabProfile => 'プロフィール';

  @override
  String get signOutTooltip => 'ログアウト';

  @override
  String get readyToScanTitle => 'スキャンの準備ができました';

  @override
  String get authenticatedAccountFallback => 'ログイン中のアカウント';

  @override
  String get scanlyProTitle => 'Scanly Pro';

  @override
  String get scanlyProSubtitle => 'OCR、クラウド同期、高度な PDF 処理を利用するにはアップグレードしてください。';

  @override
  String get nextFeaturesTitle => '次の機能';

  @override
  String get documentScannerTitle => 'ドキュメントスキャナー';

  @override
  String get documentScannerSubtitle => '撮影、紙の端の検出、切り抜き、補正、PDF 出力を行います。';

  @override
  String get nextStatus => '次';

  @override
  String get pdfToolkitTitle => 'PDF ツールキット';

  @override
  String get pdfToolkitSubtitle => '結合、分割、並べ替え、圧縮、パスワード保護、署名に対応します。';

  @override
  String get plannedStatus => '予定';

  @override
  String get ocrSearchTitle => 'OCR 検索';

  @override
  String get ocrSearchSubtitle => '文字を抽出し、ドキュメント内容を検索します。';

  @override
  String get documentsEmptyTitle => '書類はまだありません';

  @override
  String get documentsEmptySubtitle => '保存したスキャンと PDF ファイルがここに表示されます。';

  @override
  String get scanPageTitle => '新しい書類をスキャン';

  @override
  String get scanPageSubtitle => 'カメラを開いて紙の端を検出し、傾きを補正して文字を見やすくし、PDF に出力します。';

  @override
  String get startScanAction => 'スキャンを開始';

  @override
  String get toolsPageSubtitle => 'PDF ツールをここにまとめて、すばやく操作できるようにします。';

  @override
  String get profileAccountTitle => 'アカウント';

  @override
  String get profileSettingsTitle => '設定';

  @override
  String get languageSettingTitle => '言語';

  @override
  String get languageSettingSubtitle => 'Scanly の表示言語を選択します。';

  @override
  String get languagePickerTitle => '言語を選択';

  @override
  String get languageVietnamese => 'ベトナム語';

  @override
  String get languageEnglish => '英語';

  @override
  String get languageJapanese => '日本語';

  @override
  String get cloudSyncTitle => 'クラウド同期';

  @override
  String get cloudSyncSubtitle => 'バックエンド準備後に追加予定です。';

  @override
  String get signOutAction => 'ログアウト';
}
