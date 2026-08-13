import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/l10n.dart';
import '../auth/session/bloc/auth_session_bloc.dart';
import 'language/app_language.dart';
import 'language/state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({required this.userEmail, super.key});

  final String? userEmail;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final t = context.l10n;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      CupertinoIcons.person_crop_circle,
                      color: colorScheme.primary,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.profileAccountTitle, style: textTheme.titleSmall),
                      const SizedBox(height: 4),
                      Text(
                        userEmail ?? t.authenticatedAccountFallback,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(t.profileSettingsTitle, style: textTheme.titleMedium),
        const SizedBox(height: 12),
        _SettingsTile(
          key: const ValueKey('language-setting-tile'),
          icon: CupertinoIcons.globe,
          title: t.languageSettingTitle,
          onTap: () => _showLanguagePicker(context),
        ),
        const SizedBox(height: 10),
        _SettingsTile(
          icon: CupertinoIcons.cloud,
          title: t.cloudSyncTitle,
          subtitle: t.cloudSyncSubtitle,
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () {
            context.read<AuthSessionBloc>().add(
              const AuthSessionSignOutRequested(),
            );
          },
          icon: const Icon(CupertinoIcons.square_arrow_right),
          label: Text(t.signOutAction),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: colorScheme.primary, size: 24),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: textTheme.titleSmall),
                    if (subtitle case final subtitle?) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onTap != null)
                const Icon(CupertinoIcons.chevron_forward, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

void _showLanguagePicker(BuildContext context) {
  final languageCubit = context.read<ProfileLanguageCubit>();

  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return BlocProvider.value(
        value: languageCubit,
        child: const _LanguagePickerSheet(),
      );
    },
  );
}

class _LanguagePickerSheet extends StatelessWidget {
  const _LanguagePickerSheet();

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    final selectedLanguage = context.watch<ProfileLanguageCubit>().state;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              t.languagePickerTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            for (final language in AppLanguage.values)
              _LanguageOptionTile(
                language: language,
                isSelected: selectedLanguage == language,
              ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOptionTile extends StatelessWidget {
  const _LanguageOptionTile({required this.language, required this.isSelected});

  final AppLanguage language;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final t = context.l10n;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isSelected
            ? colorScheme.primary.withValues(alpha: 0.08)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          key: ValueKey('language-option-${language.code}'),
          onTap: () {
            final languageCubit = context.read<ProfileLanguageCubit>();
            Navigator.of(context).pop();
            languageCubit.languageChanged(language);
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                LanguageIcon(
                  language: language,
                  keyPrefix: 'language-option',
                  size: 30,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    language.localizedName(t),
                    style: textTheme.titleSmall?.copyWith(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color: colorScheme.primary,
                    size: 22,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LanguageIcon extends StatelessWidget {
  const LanguageIcon({
    required this.language,
    required this.keyPrefix,
    this.size = 22,
    super.key,
  });

  final AppLanguage language;
  final String keyPrefix;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        language.iconAssetPath,
        key: ValueKey('$keyPrefix-icon-${language.code}'),
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
