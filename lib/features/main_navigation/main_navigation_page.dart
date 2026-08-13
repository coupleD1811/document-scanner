import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/l10n.dart';
import '../auth/presentation/widgets/auth_failure_message.dart';
import '../auth/presentation/widgets/auth_snack_bar.dart';
import '../auth/session/bloc/auth_session_bloc.dart';
import '../documents/documents_page.dart';
import '../home/home_page.dart';
import '../profile/profile_page.dart';
import '../scan/scan_page.dart';
import '../tools/tools_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
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
        appBar: AppBar(title: Text(_titleForIndex(t, _selectedIndex))),
        body: SafeArea(
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              HomePage(userEmail: user?.email),
              const DocumentsPage(),
              const ScanPage(),
              const ToolsPage(),
              ProfilePage(userEmail: user?.email),
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
                label: t.tabHome,
                icon: CupertinoIcons.house,
                selectedIcon: CupertinoIcons.house_fill,
                isSelected: selectedIndex == 0,
                onTap: () => onChanged(0),
              ),
              _BottomTabItem(
                key: const ValueKey('bottom-tab-documents'),
                label: t.tabDocuments,
                icon: CupertinoIcons.folder,
                selectedIcon: CupertinoIcons.folder_fill,
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
                icon: CupertinoIcons.slider_horizontal_3,
                selectedIcon: CupertinoIcons.slider_horizontal_3,
                isSelected: selectedIndex == 3,
                onTap: () => onChanged(3),
              ),
              _BottomTabItem(
                key: const ValueKey('bottom-tab-profile'),
                label: t.tabProfile,
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
