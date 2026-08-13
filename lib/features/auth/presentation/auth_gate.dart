import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main_navigation/main_navigation_page.dart';
import '../login/login_page.dart';
import '../session/bloc/auth_session_bloc.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthSessionBloc, AuthSessionState>(
      buildWhen: (previous, current) =>
          previous.status != current.status || previous.user != current.user,
      builder: (context, state) {
        return switch (state.status) {
          AuthSessionStatus.unknown => const _StartupView(),
          AuthSessionStatus.unauthenticated => const LoginPage(),
          AuthSessionStatus.authenticated => const MainNavigationPage(),
        };
      },
    );
  }
}

class _StartupView extends StatelessWidget {
  const _StartupView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Icon(
                  Icons.document_scanner_outlined,
                  color: colorScheme.primary,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Scanly', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ],
        ),
      ),
    );
  }
}
