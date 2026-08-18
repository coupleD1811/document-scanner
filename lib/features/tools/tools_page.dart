import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../app/theme/scanly_icons.dart';
import '../../l10n/l10n.dart';

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;

    void showComingSoon() {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(t.toolsFeatureComingSoon)));
    }

    return ListView(
      key: const ValueKey('tools-page'),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
      children: [
        const _ToolsBrandLogo(),
        const SizedBox(height: 20),
        Text(t.toolsPageTitle, style: _pageTitleStyle(context)),
        const SizedBox(height: 6),
        Text(t.toolsPageSubtitle, style: _pageSubtitleStyle(context)),
        const SizedBox(height: 26),
        _ToolsSection(
          title: t.toolsEditOrganizeTitle,
          children: [
            _ToolsGridRow(
              left: _ToolAction(
                key: const ValueKey('tool-merge-pdf'),
                icon: ScanlyIcons.mergePdf,
                label: t.mergePdfAction,
                onPressed: showComingSoon,
              ),
              right: _ToolAction(
                key: const ValueKey('tool-split-pdf'),
                icon: ScanlyIcons.splitPdf,
                label: t.splitPdfAction,
                onPressed: showComingSoon,
              ),
            ),
            const SizedBox(height: 12),
            _ToolsGridRow(
              left: _ToolAction(
                key: const ValueKey('tool-reorder-pages'),
                icon: ScanlyIcons.reorderPages,
                label: t.reorderPagesAction,
                onPressed: showComingSoon,
              ),
              right: _ToolAction(
                key: const ValueKey('tool-delete-pages'),
                icon: ScanlyIcons.deletePages,
                label: t.deletePagesAction,
                onPressed: showComingSoon,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _ToolsSection(
          title: t.toolsConvertExtractTitle,
          children: [
            _ToolsGridRow(
              left: _ToolAction(
                key: const ValueKey('tool-image-to-pdf'),
                icon: ScanlyIcons.imageToPdf,
                label: t.quickImageToPdf,
                onPressed: showComingSoon,
              ),
              right: _ToolAction(
                key: const ValueKey('tool-ocr-text'),
                icon: ScanlyIcons.ocrText,
                label: t.ocrTextAction,
                onPressed: showComingSoon,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _ToolsSection(
          title: t.toolsOptimizeTitle,
          children: [
            _WideToolAction(
              key: const ValueKey('tool-compress-pdf'),
              icon: ScanlyIcons.compressPdf,
              label: t.compressPdfAction,
              onPressed: showComingSoon,
            ),
          ],
        ),
        const SizedBox(height: 24),
        _ToolsSection(
          title: t.toolsSecurityTitle,
          children: [
            _ToolsGridRow(
              left: _ToolAction(
                key: const ValueKey('tool-sign-document'),
                icon: ScanlyIcons.signDocument,
                label: t.quickSignDocument,
                onPressed: showComingSoon,
              ),
              right: _ToolAction(
                key: const ValueKey('tool-password-protect'),
                icon: ScanlyIcons.passwordProtect,
                label: t.quickPasswordProtect,
                onPressed: showComingSoon,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ToolsBrandLogo extends StatelessWidget {
  const _ToolsBrandLogo();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: SizedBox(
        key: const ValueKey('tools-brand-logo'),
        width: 150,
        height: 49,
        child: Image.asset(
          'images/logo/logo_icon.png',
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}

class _ToolsSection extends StatelessWidget {
  const _ToolsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: _sectionTitleStyle(context)),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

class _ToolsGridRow extends StatelessWidget {
  const _ToolsGridRow({required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: left),
          const SizedBox(width: 12),
          Expanded(child: right),
        ],
      ),
    );
  }
}

class _ToolAction extends StatelessWidget {
  const _ToolAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFFDDE5EC)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: colorScheme.primary, size: 36),
              const SizedBox(height: 10),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WideToolAction extends StatelessWidget {
  const _WideToolAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 72,
      child: Material(
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFFDDE5EC)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Icon(icon, color: colorScheme.primary, size: 34),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  LucideIcons.chevronRight,
                  color: colorScheme.onSurfaceVariant,
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

TextStyle? _pageTitleStyle(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  return Theme.of(context).textTheme.headlineLarge?.copyWith(
    color: colorScheme.onSurface,
    fontWeight: FontWeight.w800,
  );
}

TextStyle? _pageSubtitleStyle(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  return Theme.of(context).textTheme.bodyLarge?.copyWith(
    color: colorScheme.onSurfaceVariant,
    height: 1.35,
  );
}

TextStyle? _sectionTitleStyle(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  return Theme.of(context).textTheme.titleLarge?.copyWith(
    color: colorScheme.onSurface,
    fontWeight: FontWeight.w700,
  );
}
