import 'package:flutter/cupertino.dart';

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
          icon: CupertinoIcons.slider_horizontal_3,
          title: t.pdfToolkitTitle,
          subtitle: t.toolsPageSubtitle,
          isInScrollView: true,
        ),
        const SizedBox(height: 16),
        ModuleTile(
          icon: CupertinoIcons.doc_on_doc,
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
