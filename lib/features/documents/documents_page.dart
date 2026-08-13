import 'package:flutter/cupertino.dart';

import '../../l10n/l10n.dart';
import '../shared/widgets/empty_feature_view.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;

    return EmptyFeatureView(
      icon: CupertinoIcons.folder,
      title: t.documentsEmptyTitle,
      subtitle: t.documentsEmptySubtitle,
    );
  }
}
