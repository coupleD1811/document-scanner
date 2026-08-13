import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../shared/widgets/module_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({required this.userEmail, super.key});

  final String? userEmail;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final t = context.l10n;

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
                  t.readyToScanTitle,
                  style: textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  userEmail ?? t.authenticatedAccountFallback,
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
                      Text(t.scanlyProTitle, style: textTheme.titleSmall),
                      const SizedBox(height: 4),
                      Text(
                        t.scanlyProSubtitle,
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
        Text(t.nextFeaturesTitle, style: textTheme.titleMedium),
        const SizedBox(height: 12),
        ModuleTile(
          icon: CupertinoIcons.doc_text_viewfinder,
          title: t.documentScannerTitle,
          subtitle: t.documentScannerSubtitle,
          status: t.nextStatus,
        ),
        const SizedBox(height: 10),
        ModuleTile(
          icon: CupertinoIcons.wrench,
          title: t.pdfToolkitTitle,
          subtitle: t.pdfToolkitSubtitle,
          status: t.plannedStatus,
        ),
        const SizedBox(height: 10),
        ModuleTile(
          icon: CupertinoIcons.doc_text_search,
          title: t.ocrSearchTitle,
          subtitle: t.ocrSearchSubtitle,
          status: t.plannedStatus,
        ),
      ],
    );
  }
}
