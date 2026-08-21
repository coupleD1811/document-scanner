import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:scanly/l10n/l10n.dart';

import '../../app/theme/scanly_theme_cubit.dart';

import '../auth/session/bloc/auth_session_bloc.dart';
import 'language/app_language.dart';
import 'language/state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({required this.userEmail, super.key});

  final String? userEmail;

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    final profileName = _profileNameFromEmail(
      userEmail,
      t.authenticatedAccountFallback,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        _AccountCard(profileName: profileName, userEmail: userEmail),
        const SizedBox(height: 18),
        _ProfileSectionTitle(t.profileAppearanceTitle),
        const SizedBox(height: 8),
        const _ThemeModeGroup(),
        const SizedBox(height: 18),
        _ProfileSectionTitle(t.profileLanguageSectionTitle),
        const SizedBox(height: 8),
        const _LanguageGroup(),
        const SizedBox(height: 18),
        _ProfileSectionTitle(t.profileAccountSecurityTitle),
        const SizedBox(height: 8),
        _ProfileGroup(
          children: [
            _ProfileRow(
              icon: LucideIcons.contactRound,
              title: t.profileAccountInformation,
              onTap: () => _showFeatureComingSoon(context),
            ),
            _ProfileRow(
              icon: LucideIcons.keyRound,
              title: t.profileChangePassword,
              onTap: () => _showFeatureComingSoon(context),
            ),
            _ProfileRow(
              icon: LucideIcons.shieldCheck,
              title: t.profilePrivacySecurity,
              onTap: () => _showFeatureComingSoon(context),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _ProfileSectionTitle(t.profileInformationSupportTitle),
        const SizedBox(height: 8),
        _ProfileGroup(
          children: [
            _ProfileRow(
              icon: LucideIcons.fileText,
              title: t.profileTermsOfService,
              onTap: () => _showFeatureComingSoon(context),
            ),
            _ProfileRow(
              icon: LucideIcons.shieldCheck,
              title: t.profilePrivacyPolicy,
              onTap: () => _showFeatureComingSoon(context),
            ),
            _ProfileRow(
              icon: LucideIcons.info,
              title: t.profileAboutScanly,
              subtitle: t.profileVersionValue,
              onTap: () => _showFeatureComingSoon(context),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _ProfileGroup(
          children: [
            _ProfileRow(
              key: const ValueKey('profile-sign-out'),
              icon: LucideIcons.logOut,
              title: t.signOutAction,
              foregroundColor: Theme.of(context).colorScheme.error,
              onTap: () {
                context.read<AuthSessionBloc>().add(
                  const AuthSessionSignOutRequested(),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

String _profileNameFromEmail(String? email, String fallback) {
  final normalizedEmail = email?.trim() ?? '';
  if (normalizedEmail.isEmpty) {
    return fallback;
  }

  final atIndex = normalizedEmail.indexOf('@');
  final name = atIndex > 0
      ? normalizedEmail.substring(0, atIndex)
      : normalizedEmail;
  return name.isEmpty ? fallback : name;
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.profileName, required this.userEmail});

  final String profileName;
  final String? userEmail;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final t = context.l10n;
    final initial = profileName.characters.first.toUpperCase();

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 10, 8),
        child: Column(
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [colorScheme.primary, colorScheme.secondary],
                    ),
                  ),
                  child: SizedBox.square(
                    dimension: 64,
                    child: Center(
                      child: Text(
                        initial,
                        style: textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        userEmail ?? t.authenticatedAccountFallback,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 7),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.32),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          child: Text(
                            t.profileFreePlan,
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                key: const ValueKey('upgrade-to-pro'),
                onPressed: () => _showFeatureComingSoon(context),
                icon: const Icon(LucideIcons.crown, size: 18),
                label: Text(t.profileUpgradeToPro),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeModeGroup extends StatelessWidget {
  const _ThemeModeGroup();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScanlyThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == ThemeMode.dark;
        final t = context.l10n;

        return _ProfileGroup(
          children: [
            _ProfileRow(
              icon: isDark ? LucideIcons.sun : LucideIcons.moon,
              title: t.profileThemeSettingTitle,
              onTap: context.read<ScanlyThemeCubit>().toggleTheme,
              showChevron: false,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isDark ? t.themeModeDark : t.themeModeLight,
                    key: const ValueKey('theme-mode-label'),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    key: const ValueKey('theme-mode-switch'),
                    value: isDark,
                    onChanged: (value) => context
                        .read<ScanlyThemeCubit>()
                        .themeChanged(isDark: value),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LanguageGroup extends StatelessWidget {
  const _LanguageGroup();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileLanguageCubit, AppLanguage>(
      builder: (context, language) {
        final t = context.l10n;

        return _ProfileGroup(
          children: [
            _ProfileRow(
              key: const ValueKey('language-setting-tile'),
              icon: LucideIcons.languages,
              title: t.languageSettingTitle,
              onTap: () => _showLanguagePicker(context),
              showChevron: false,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LanguageIcon(
                    language: language,
                    keyPrefix: 'current-language',
                  ),
                  const SizedBox(width: 8),
                  Text(
                    language.localizedName(t),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    LucideIcons.chevronRight,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProfileSectionTitle extends StatelessWidget {
  const _ProfileSectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _ProfileGroup extends StatelessWidget {
  const _ProfileGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var index = 0; index < children.length; index++) ...[
            children[index],
            if (index != children.length - 1)
              Divider(indent: 52, color: colorScheme.outlineVariant),
          ],
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.foregroundColor,
    this.showChevron = true,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? foregroundColor;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final color = foregroundColor ?? colorScheme.primary;

    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 54),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        color: foregroundColor ?? colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (subtitle case final subtitle?) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing case final trailing?) trailing,
              if (trailing == null && showChevron)
                Icon(
                  LucideIcons.chevronRight,
                  color: foregroundColor ?? colorScheme.onSurfaceVariant,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showFeatureComingSoon(BuildContext context) {
  final messenger = ScaffoldMessenger.of(context);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(context.l10n.profileFeatureComingSoon)),
    );
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: ValueKey('language-option-${language.code}'),
          onTap: () {
            final languageCubit = context.read<ProfileLanguageCubit>();
            Navigator.of(context).pop();
            languageCubit.languageChanged(language);
          },
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
                    LucideIcons.circleCheckBig,
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
