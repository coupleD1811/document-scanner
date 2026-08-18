import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../app/theme/scanly_icons.dart';
import '../../l10n/l10n.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.userEmail,
    required this.onScanPressed,
    required this.onDocumentsPressed,
    required this.onToolsPressed,
    super.key,
  });

  final String? userEmail;
  final VoidCallback onScanPressed;
  final VoidCallback onDocumentsPressed;
  final VoidCallback onToolsPressed;

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        _HomeHeader(
          greeting: _homeGreetingText(t, userEmail),
          subtitle: t.homeWorkspaceSubtitle,
        ),
        const SizedBox(height: 24),
        _ScanCallToAction(
          title: t.homeScanDocumentAction,
          subtitle: t.homeScanDocumentSubtitle,
          onPressed: onScanPressed,
        ),
        const SizedBox(height: 26),
        Text(t.homeQuickActionsTitle, style: _sectionTitleStyle(context)),
        const SizedBox(height: 12),
        _QuickActionsGrid(
          actions: [
            _HomeAction(
              icon: ScanlyIcons.imageToPdf,
              title: t.quickImageToPdf,
              onPressed: onToolsPressed,
            ),
            _HomeAction(
              icon: ScanlyIcons.importPdf,
              title: t.quickImportPdf,
              onPressed: onDocumentsPressed,
            ),
            _HomeAction(
              icon: ScanlyIcons.ocrText,
              title: t.quickOcr,
              onPressed: onToolsPressed,
            ),
            _HomeAction(
              icon: ScanlyIcons.compressPdf,
              title: t.quickCompressPdf,
              onPressed: onToolsPressed,
            ),
            _HomeAction(
              icon: ScanlyIcons.signDocument,
              title: t.quickSignDocument,
              onPressed: onToolsPressed,
            ),
            _HomeAction(
              icon: ScanlyIcons.passwordProtect,
              title: t.quickPasswordProtect,
              onPressed: onToolsPressed,
            ),
          ],
        ),
        const SizedBox(height: 28),
        _SectionHeader(
          title: t.homeRecentDocumentsTitle,
          actionLabel: t.viewAllAction,
          onActionPressed: onDocumentsPressed,
        ),
        const SizedBox(height: 12),
        _RecentDocumentsEmptyState(
          title: t.homeNoRecentDocumentsTitle,
          subtitle: t.homeNoRecentDocumentsSubtitle,
          onPressed: onScanPressed,
        ),
        const SizedBox(height: 28),
        _SectionHeader(
          title: t.pdfToolkitTitle,
          actionLabel: t.allToolsAction,
          onActionPressed: onToolsPressed,
        ),
        const SizedBox(height: 12),
        _ToolkitGrid(
          tools: [
            _HomeAction(
              icon: ScanlyIcons.mergePdf,
              title: t.mergePdfAction,
              onPressed: onToolsPressed,
            ),
            _HomeAction(
              icon: ScanlyIcons.splitPdf,
              title: t.splitPdfAction,
              onPressed: onToolsPressed,
            ),
            _HomeAction(
              icon: ScanlyIcons.reorderPages,
              title: t.reorderPagesAction,
              onPressed: onToolsPressed,
            ),
            _HomeAction(
              icon: ScanlyIcons.compressPdf,
              title: t.compressPdfAction,
              onPressed: onToolsPressed,
            ),
          ],
        ),
        const SizedBox(height: 20),
        _ScanlyProBanner(
          title: t.scanlyProTitle,
          subtitle: t.homeScanlyProSubtitle,
          actionLabel: t.upgradeAction,
        ),
      ],
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.greeting, required this.subtitle});

  final String greeting;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const _HomeBrandLogo(),
            const Spacer(),
            _HeaderIconButton(
              icon: LucideIcons.search,
              color: colorScheme.onSurface,
              onPressed: () {},
            ),
            const SizedBox(width: 8),
            _HeaderIconButton(
              icon: LucideIcons.bell,
              color: colorScheme.onSurface,
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 22),
        Text(
          greeting,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _HomeBrandLogo extends StatelessWidget {
  const _HomeBrandLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const ValueKey('home-brand-logo'),
      width: 178,
      height: 58,
      child: Image.asset(
        'images/logo/logo_icon.png',
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      minimumSize: const Size.square(40),
      padding: EdgeInsets.zero,
      child: Icon(icon, color: color, size: 28),
    );
  }
}

class _ScanCallToAction extends StatelessWidget {
  const _ScanCallToAction({
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colorScheme.primary,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.onPrimary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.onPrimary.withValues(alpha: 0.24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Icon(
                    ScanlyIcons.scanDocument,
                    color: colorScheme.onPrimary,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimary.withValues(alpha: 0.86),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                LucideIcons.chevronRight,
                color: colorScheme.onPrimary,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({required this.actions});

  final List<_HomeAction> actions;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 360 ? 2 : 3;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: crossAxisCount == 2 ? 1.58 : 1.28,
          ),
          itemBuilder: (context, index) {
            final action = actions[index];

            return _QuickActionTile(action: action);
          },
        );
      },
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.action});

  final _HomeAction action;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: action.onPressed,
        borderRadius: BorderRadius.circular(8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDDE5EC)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(action.icon, color: colorScheme.primary, size: 29),
                const SizedBox(height: 10),
                Text(
                  action.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onActionPressed,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onActionPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(child: Text(title, style: _sectionTitleStyle(context))),
        CupertinoButton(
          onPressed: onActionPressed,
          minimumSize: const Size(0, 36),
          padding: const EdgeInsets.only(left: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                actionLabel,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                LucideIcons.chevronRight,
                color: colorScheme.primary,
                size: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecentDocumentsEmptyState extends StatelessWidget {
  const _RecentDocumentsEmptyState({
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDDE5EC)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.72,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Icon(
                      LucideIcons.inbox,
                      color: colorScheme.onSurfaceVariant,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: textTheme.bodyMedium?.copyWith(
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
      ),
    );
  }
}

class _ToolkitGrid extends StatelessWidget {
  const _ToolkitGrid({required this.tools});

  final List<_HomeAction> tools;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tools.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.85,
      ),
      itemBuilder: (context, index) {
        return _ToolkitTile(action: tools[index]);
      },
    );
  }
}

class _ToolkitTile extends StatelessWidget {
  const _ToolkitTile({required this.action});

  final _HomeAction action;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: action.onPressed,
        borderRadius: BorderRadius.circular(8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDDE5EC)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Icon(action.icon, color: colorScheme.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    action.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScanlyProBanner extends StatelessWidget {
  const _ScanlyProBanner({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
  });

  final String title;
  final String subtitle;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.secondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.secondary.withValues(alpha: 0.28),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  LucideIcons.sparkles,
                  color: colorScheme.onPrimary,
                  size: 26,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 44),
                padding: const EdgeInsets.symmetric(horizontal: 18),
              ),
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeAction {
  const _HomeAction({
    required this.icon,
    required this.title,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final VoidCallback onPressed;
}

TextStyle? _sectionTitleStyle(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  return Theme.of(context).textTheme.titleLarge?.copyWith(
    color: colorScheme.onSurface,
    fontWeight: FontWeight.w800,
  );
}

String? _displayNameFromEmail(String? email) {
  final normalizedEmail = email?.trim();
  if (normalizedEmail == null || normalizedEmail.isEmpty) {
    return null;
  }

  final atIndex = normalizedEmail.indexOf('@');
  final name = atIndex <= 0
      ? normalizedEmail
      : normalizedEmail.substring(0, atIndex);

  return name.trim().isEmpty ? null : name.trim();
}

String _homeGreetingText(AppLocalizations t, String? email) {
  final displayName = _displayNameFromEmail(email);
  if (displayName == null) {
    return t.homeWelcomeGeneric;
  }

  return switch (t.localeName) {
    'ja' => '$displayNameさん、おかえりなさい',
    _ => '${t.homeWelcomeGeneric}, $displayName',
  };
}
