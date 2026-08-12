import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/l10n.dart';
import '../session/bloc/auth_session_bloc.dart';
import 'auth_failure_message.dart';
import 'auth_snack_bar.dart';

class HomeShellPage extends StatefulWidget {
  const HomeShellPage({super.key});

  @override
  State<HomeShellPage> createState() => _HomeShellPageState();
}

class _HomeShellPageState extends State<HomeShellPage> {
  static const _scanTabIndex = 2;

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthSessionBloc bloc) => bloc.state.user);
    final l10n = context.l10n;

    return BlocListener<AuthSessionBloc, AuthSessionState>(
      listenWhen: (previous, current) =>
          previous.failureCode != current.failureCode &&
          current.failureCode != null,
      listener: (context, state) {
        showAuthSnackBar(
          context,
          message: state.failureCode!.localizedMessage(context.l10n),
          isError: true,
        );
      },
      child: Scaffold(
        appBar: AppBar(title: Text(_titleForIndex(l10n, _selectedIndex))),
        body: SafeArea(
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              _HomeTabView(userEmail: user?.email),
              const _DocumentsTabView(),
              const _ScanTabView(),
              const _ToolsTabView(),
              _ProfileTabView(userEmail: user?.email),
            ],
          ),
        ),
        bottomNavigationBar: _ScanlyBottomBar(
          selectedIndex: _selectedIndex,
          scanTabIndex: _scanTabIndex,
          onChanged: (index) {
            setState(() => _selectedIndex = index);
          },
        ),
      ),
    );
  }
}

String _titleForIndex(AppLocalizations l10n, int index) {
  return switch (index) {
    0 => l10n.appTitle,
    1 => l10n.tabDocuments,
    2 => l10n.tabScan,
    3 => l10n.tabTools,
    4 => l10n.tabProfile,
    _ => l10n.appTitle,
  };
}

class _HomeTabView extends StatelessWidget {
  const _HomeTabView({required this.userEmail});

  final String? userEmail;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.readyToScanTitle,
                  style: textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  userEmail ?? l10n.authenticatedAccountFallback,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimary.withValues(alpha: 0.84),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      CupertinoIcons.sparkles,
                      color: colorScheme.secondary,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.scanlyProTitle, style: textTheme.titleSmall),
                      const SizedBox(height: 4),
                      Text(
                        l10n.scanlyProSubtitle,
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
        const SizedBox(height: 24),
        Text(l10n.nextFeaturesTitle, style: textTheme.titleMedium),
        const SizedBox(height: 12),
        _ModuleTile(
          icon: CupertinoIcons.doc_text_viewfinder,
          title: l10n.documentScannerTitle,
          subtitle: l10n.documentScannerSubtitle,
          status: l10n.nextStatus,
        ),
        const SizedBox(height: 10),
        _ModuleTile(
          icon: CupertinoIcons.wrench,
          title: l10n.pdfToolkitTitle,
          subtitle: l10n.pdfToolkitSubtitle,
          status: l10n.plannedStatus,
        ),
        const SizedBox(height: 10),
        _ModuleTile(
          icon: CupertinoIcons.doc_text_search,
          title: l10n.ocrSearchTitle,
          subtitle: l10n.ocrSearchSubtitle,
          status: l10n.plannedStatus,
        ),
      ],
    );
  }
}

class _DocumentsTabView extends StatelessWidget {
  const _DocumentsTabView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _EmptyTabView(
      icon: CupertinoIcons.folder,
      title: l10n.documentsEmptyTitle,
      subtitle: l10n.documentsEmptySubtitle,
    );
  }
}

class _ScanTabView extends StatelessWidget {
  const _ScanTabView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Icon(
                      CupertinoIcons.doc_text_viewfinder,
                      color: colorScheme.primary,
                      size: 72,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.scanPageTitle,
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.scanPageSubtitle,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.doc_text_viewfinder),
                label: Text(l10n.startScanAction),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolsTabView extends StatelessWidget {
  const _ToolsTabView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        _EmptyTabView(
          icon: CupertinoIcons.slider_horizontal_3,
          title: l10n.pdfToolkitTitle,
          subtitle: l10n.toolsPageSubtitle,
          isInScrollView: true,
        ),
        const SizedBox(height: 16),
        _ModuleTile(
          icon: CupertinoIcons.doc_on_doc,
          title: l10n.pdfToolkitTitle,
          subtitle: l10n.pdfToolkitSubtitle,
          status: l10n.plannedStatus,
        ),
        const SizedBox(height: 10),
        _ModuleTile(
          icon: CupertinoIcons.doc_text_search,
          title: l10n.ocrSearchTitle,
          subtitle: l10n.ocrSearchSubtitle,
          status: l10n.plannedStatus,
        ),
      ],
    );
  }
}

class _ProfileTabView extends StatelessWidget {
  const _ProfileTabView({required this.userEmail});

  final String? userEmail;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

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
                      Text(
                        l10n.profileAccountTitle,
                        style: textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userEmail ?? l10n.authenticatedAccountFallback,
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
        Text(l10n.profileSettingsTitle, style: textTheme.titleMedium),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: CupertinoIcons.globe,
          title: l10n.languageSettingTitle,
          subtitle: l10n.languageSettingSubtitle,
        ),
        const SizedBox(height: 10),
        _SettingsTile(
          icon: CupertinoIcons.cloud,
          title: l10n.cloudSyncTitle,
          subtitle: l10n.cloudSyncSubtitle,
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () {
            context.read<AuthSessionBloc>().add(
              const AuthSessionSignOutRequested(),
            );
          },
          icon: const Icon(CupertinoIcons.square_arrow_right),
          label: Text(l10n.signOutAction),
        ),
      ],
    );
  }
}

class _ScanlyBottomBar extends StatelessWidget {
  const _ScanlyBottomBar({
    required this.selectedIndex,
    required this.scanTabIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final int scanTabIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: const Border(top: BorderSide(color: Color(0xFFE3E8EC))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 84,
          child: Row(
            children: [
              _BottomTabItem(
                key: const ValueKey('bottom-tab-home'),
                label: l10n.tabHome,
                icon: CupertinoIcons.house,
                selectedIcon: CupertinoIcons.house_fill,
                isSelected: selectedIndex == 0,
                onTap: () => onChanged(0),
              ),
              _BottomTabItem(
                key: const ValueKey('bottom-tab-documents'),
                label: l10n.tabDocuments,
                icon: CupertinoIcons.folder,
                selectedIcon: CupertinoIcons.folder_fill,
                isSelected: selectedIndex == 1,
                onTap: () => onChanged(1),
              ),
              _ScanTabButton(
                key: const ValueKey('bottom-tab-scan'),
                label: l10n.tabScan,
                isSelected: selectedIndex == scanTabIndex,
                onTap: () => onChanged(scanTabIndex),
              ),
              _BottomTabItem(
                key: const ValueKey('bottom-tab-tools'),
                label: l10n.tabTools,
                icon: CupertinoIcons.slider_horizontal_3,
                selectedIcon: CupertinoIcons.slider_horizontal_3,
                isSelected: selectedIndex == 3,
                onTap: () => onChanged(3),
              ),
              _BottomTabItem(
                key: const ValueKey('bottom-tab-profile'),
                label: l10n.tabProfile,
                icon: CupertinoIcons.person_crop_circle,
                selectedIcon: CupertinoIcons.person_crop_circle_fill,
                isSelected: selectedIndex == 4,
                onTap: () => onChanged(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomTabItem extends StatelessWidget {
  const _BottomTabItem({
    super.key,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final color = isSelected ? colorScheme.primary : const Color(0xFF94A3B8);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 84,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isSelected ? selectedIcon : icon, color: color, size: 23),
              const SizedBox(height: 5),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanTabButton extends StatelessWidget {
  const _ScanTabButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 84,
          child: Transform.translate(
            offset: const Offset(0, -14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.08 : 1,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: colorScheme.secondary.withValues(
                          alpha: isSelected ? 0.85 : 0.32,
                        ),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.26),
                          blurRadius: isSelected ? 18 : 12,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      CupertinoIcons.doc_text_viewfinder,
                      color: colorScheme.onPrimary,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w800,
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

class _EmptyTabView extends StatelessWidget {
  const _EmptyTabView({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isInScrollView = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isInScrollView;

  @override
  Widget build(BuildContext context) {
    final content = _EmptyTabContent(
      icon: icon,
      title: title,
      subtitle: subtitle,
    );

    if (isInScrollView) {
      return content;
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: content,
      ),
    );
  }
}

class _EmptyTabContent extends StatelessWidget {
  const _EmptyTabContent({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Icon(icon, color: colorScheme.primary, size: 44),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleTile extends StatelessWidget {
  const _ModuleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String status;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.secondary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(icon, color: colorScheme.secondary),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                child: Text(status, style: textTheme.labelSmall),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
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
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(CupertinoIcons.chevron_forward, size: 18),
          ],
        ),
      ),
    );
  }
}
