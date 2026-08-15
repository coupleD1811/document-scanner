import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../features/auth/repository/auth_repository.dart';
import '../features/auth/session/bloc/auth_session_bloc.dart';
import '../features/auth/presentation/auth_gate.dart';
import '../features/profile/language/app_language.dart';
import '../features/profile/language/state.dart';
import '../l10n/l10n.dart';
import 'theme/scanly_theme.dart';

class ScanlyApp extends StatelessWidget {
  const ScanlyApp({required this.authRepository, this.locale, super.key});

  final AuthRepository authRepository;
  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                ProfileLanguageCubit(initialLocale: locale)
                  ..restoreSavedLanguage(),
          ),
          BlocProvider(
            create: (_) =>
                AuthSessionBloc(authRepository: authRepository)
                  ..add(const AuthSessionSubscriptionRequested()),
          ),
        ],
        child: BlocBuilder<ProfileLanguageCubit, AppLanguage>(
          builder: (context, language) {
            return MaterialApp(
              onGenerateTitle: (context) => context.l10n.appTitle,
              debugShowCheckedModeBanner: false,
              locale: language.locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              localeResolutionCallback: _resolveLocale,
              theme: ScanlyTheme.light(),
              home: const AuthGate(),
            );
          },
        ),
      ),
    );
  }
}

class FirebaseSetupApp extends StatelessWidget {
  const FirebaseSetupApp({required this.error, this.locale, super.key});

  final Object error;
  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: _resolveLocale,
      theme: ScanlyTheme.light(),
      home: Builder(
        builder: (context) {
          final t = context.l10n;

          return Scaffold(
            body: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(LucideIcons.scanLine, size: 48),
                        const SizedBox(height: 20),
                        Text(
                          t.firebaseNotConfiguredTitle,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          t.firebaseNotConfiguredBody,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 20),
                        const _SetupStep(
                          command: 'dart pub global activate flutterfire_cli',
                        ),
                        const _SetupStep(command: 'flutterfire configure'),
                        const _SetupStep(command: 'flutter run'),
                        const SizedBox(height: 20),
                        Text(
                          t.startupErrorTitle,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          error.toString(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Locale _resolveLocale(Locale? locale, Iterable<Locale> supportedLocales) {
  if (locale == null) {
    return const Locale('vi');
  }

  for (final supportedLocale in supportedLocales) {
    if (supportedLocale.languageCode == locale.languageCode) {
      return supportedLocale;
    }
  }

  return const Locale('vi');
}

class _SetupStep extends StatelessWidget {
  const _SetupStep({required this.command});

  final String command;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(LucideIcons.terminal, size: 18, color: colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: SelectableText(
                  command,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
