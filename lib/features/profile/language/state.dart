import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_language.dart';

class ProfileLanguageCubit extends Cubit<AppLanguage> {
  ProfileLanguageCubit({Locale? initialLocale})
    : super(AppLanguage.fromLocale(initialLocale));

  static const _languageCodeKey = 'scanly.language_code';

  Future<void> restoreSavedLanguage() async {
    final preferences = await SharedPreferences.getInstance();
    final savedLanguage = AppLanguage.fromCode(
      preferences.getString(_languageCodeKey),
    );

    if (savedLanguage == null || isClosed || savedLanguage == state) {
      return;
    }

    emit(savedLanguage);
  }

  void languageChanged(AppLanguage language) {
    if (state == language) {
      return;
    }

    emit(language);
    unawaited(_saveLanguage(language));
  }

  Future<void> _saveLanguage(AppLanguage language) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_languageCodeKey, language.code);
  }
}
