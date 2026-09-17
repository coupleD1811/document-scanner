import 'dart:io';

import 'package:open_filex/open_filex.dart';

import '../model/local_document.dart';

abstract interface class DocumentFileOpener {
  Future<void> open(LocalDocument document);
}

class SystemDocumentFileOpener implements DocumentFileOpener {
  const SystemDocumentFileOpener();

  @override
  Future<void> open(LocalDocument document) async {
    final file = File(document.pdfPath);
    if (!await file.exists()) {
      throw FileSystemException(
        'Document PDF does not exist.',
        document.pdfPath,
      );
    }

    final result = await OpenFilex.open(document.pdfPath);
    if (result.type != ResultType.done) {
      throw StateError(result.message);
    }
  }
}
