import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';

enum AppLanguage {
  vietnamese(Locale('vi'), 'images/assets/vietnam.png'),
  english(Locale('en'), 'images/assets/england.png'),
  japanese(Locale('ja'), 'images/assets/japan.png');

  const AppLanguage(this.locale, this.iconAssetPath);

  final Locale locale;
  final String iconAssetPath;

  String get code => locale.languageCode;

  static AppLanguage fromLocale(Locale? locale) {
    return fromCode(locale?.languageCode) ?? AppLanguage.vietnamese;
  }

  static AppLanguage? fromCode(String? code) {
    return switch (code) {
      'en' => AppLanguage.english,
      'ja' => AppLanguage.japanese,
      'vi' => AppLanguage.vietnamese,
      _ => null,
    };
  }

  String localizedName(AppLocalizations t) {
    return switch (this) {
      AppLanguage.vietnamese => t.languageVietnamese,
      AppLanguage.english => t.languageEnglish,
      AppLanguage.japanese => t.languageJapanese,
    };
  }
}
