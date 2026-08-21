import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanlyThemeCubit extends Cubit<ThemeMode> {
  ScanlyThemeCubit() : super(ThemeMode.light);

  static const _themeModeKey = 'scanly.theme_mode';

  Future<void> restoreSavedTheme() async {
    final preferences = await SharedPreferences.getInstance();
    final savedTheme = preferences.getString(_themeModeKey);
    final themeMode = savedTheme == ThemeMode.dark.name
        ? ThemeMode.dark
        : ThemeMode.light;

    if (isClosed || themeMode == state) {
      return;
    }

    emit(themeMode);
  }

  void themeChanged({required bool isDark}) {
    final themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    if (themeMode == state) {
      return;
    }

    emit(themeMode);
    unawaited(_saveTheme(themeMode));
  }

  void toggleTheme() {
    themeChanged(isDark: state != ThemeMode.dark);
  }

  Future<void> _saveTheme(ThemeMode themeMode) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_themeModeKey, themeMode.name);
  }
}
