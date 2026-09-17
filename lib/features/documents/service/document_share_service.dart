import 'dart:io';

import 'package:share_plus/share_plus.dart';

import '../model/local_document.dart';

abstract interface class DocumentShareService {
  Future<void> share(LocalDocument document);
}

class SystemDocumentShareService implements DocumentShareService {
  const SystemDocumentShareService();

  @override
  Future<void> share(LocalDocument document) async {
    final file = File(document.pdfPath);
    if (!await file.exists()) {
      throw FileSystemException(
        'Document PDF does not exist.',
        document.pdfPath,
      );
    }

    await SharePlus.instance.share(
      ShareParams(files: [XFile(document.pdfPath)], subject: document.name),
    );
  }
}
