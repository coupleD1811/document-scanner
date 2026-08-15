import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../l10n/l10n.dart';
import '../shared/widgets/empty_feature_view.dart';
import '../shared/widgets/module_tile.dart';

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      children: [
        EmptyFeatureView(
          icon: LucideIcons.slidersHorizontal,
          title: t.pdfToolkitTitle,
          subtitle: t.toolsPageSubtitle,
          isInScrollView: true,
        ),
        const SizedBox(height: 16),
        ModuleTile(
          icon: LucideIcons.combine,
          title: t.pdfToolkitTitle,
          subtitle: t.pdfToolkitSubtitle,
          status: t.plannedStatus,
        ),
        const SizedBox(height: 10),
        ModuleTile(
          icon: LucideIcons.fileSearch,
          title: t.ocrSearchTitle,
          subtitle: t.ocrSearchSubtitle,
          status: t.plannedStatus,
        ),
      ],
    );
  }
}
