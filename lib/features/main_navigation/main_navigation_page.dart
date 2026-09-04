import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../app/theme/scanly_icons.dart';
import '../../l10n/l10n.dart';
import '../auth/presentation/widgets/auth_failure_message.dart';
import '../auth/presentation/widgets/auth_snack_bar.dart';
import '../auth/session/bloc/auth_session_bloc.dart';
import '../documents/view/page.dart';
import '../home/home_page.dart';
import '../profile/profile_page.dart';
import '../scan/bloc/scan_session_bloc.dart';
import '../scan/model/normalized_document_image.dart';
import '../scan/view/scan_camera_page.dart';
import '../scan/view/scan_editor_page.dart';
import '../tools/tools_page.dart';

class MainNavigationPage extends StatelessWidget {
  const MainNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScanSessionBloc(),
      child: const _MainNavigationView(),
    );
  }
}

class _MainNavigationView extends StatefulWidget {
  const _MainNavigationView();

  @override
  State<_MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<_MainNavigationView> {
  static const _scanTabIndex = 2;

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthSessionBloc bloc) => bloc.state.user);
    final t = context.l10n;

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
        appBar:
            _selectedIndex == 0 || _selectedIndex == 1 || _selectedIndex == 3
            ? null
            : AppBar(title: Text(_titleForIndex(t, _selectedIndex))),
        body: SafeArea(
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              HomePage(
                userEmail: user?.email,
                onScanPressed: () => _selectTab(_scanTabIndex),
                onDocumentsPressed: () => _selectTab(1),
                onToolsPressed: () => _selectTab(3),
              ),
              DocumentsPage(onScanPressed: () => _selectTab(_scanTabIndex)),
              const SizedBox.shrink(),
              const ToolsPage(),
              ProfilePage(userEmail: user?.email),
            ],
          ),
        ),
        bottomNavigationBar: _ScanlyBottomBar(
          selectedIndex: _selectedIndex,
          scanTabIndex: _scanTabIndex,
          onChanged: _selectTab,
        ),
      ),
    );
  }

  void _selectTab(int index) {
    if (index == _scanTabIndex) {
      unawaited(_openScanner());
      return;
    }

    setState(() => _selectedIndex = index);
  }

  Future<void> _openScanner() async {
    final sessionBloc = context.read<ScanSessionBloc>();
    sessionBloc.add(const ScanSessionCleared());
    final image = await Navigator.of(context).push<NormalizedDocumentImage>(
      MaterialPageRoute(builder: (_) => const ScanCameraPage()),
    );
    if (!mounted || image == null) {
      return;
    }

    sessionBloc.add(ScanSessionPageAdded(image));
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: sessionBloc,
          child: const ScanEditorPage(),
        ),
      ),
    );
  }
}

String _titleForIndex(AppLocalizations t, int index) {
  return switch (index) {
    0 => t.appTitle,
    1 => t.tabDocuments,
    2 => t.tabScan,
    3 => t.tabTools,
    4 => t.tabProfile,
    _ => t.appTitle,
  };
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
    final t = context.l10n;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
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
                label: t.tabHome,
                icon: LucideIcons.house,
                selectedIcon: LucideIcons.house600,
                isSelected: selectedIndex == 0,
                onTap: () => onChanged(0),
              ),
              _BottomTabItem(
                key: const ValueKey('bottom-tab-documents'),
                label: t.tabDocuments,
                icon: LucideIcons.folder,
                selectedIcon: LucideIcons.folder600,
                isSelected: selectedIndex == 1,
                onTap: () => onChanged(1),
              ),
              _ScanTabButton(
                key: const ValueKey('bottom-tab-scan'),
                label: t.tabScan,
                isSelected: selectedIndex == scanTabIndex,
                onTap: () => onChanged(scanTabIndex),
              ),
              _BottomTabItem(
                key: const ValueKey('bottom-tab-tools'),
                label: t.tabTools,
                icon: LucideIcons.slidersHorizontal,
                selectedIcon: LucideIcons.slidersHorizontal600,
                isSelected: selectedIndex == 3,
                onTap: () => onChanged(3),
              ),
              _BottomTabItem(
                key: const ValueKey('bottom-tab-profile'),
                label: t.tabProfile,
                icon: LucideIcons.circleUserRound,
                selectedIcon: LucideIcons.circleUserRound600,
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
    final color = isSelected
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

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
                      ScanlyIcons.scanDocument,
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
