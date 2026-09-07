import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../model/page_save_draft.dart';
import '../model/save_draft.dart';
import '../model/stored_document_files.dart';

typedef DocumentRootDirectoryLoader = Future<Directory> Function();

abstract interface class DocumentStorage {
  Future<StoredDocumentFiles> storePageImages(DocumentSaveDraft draft);

  Future<void> deleteDocumentFiles(String directoryPath);
}

class DocumentStorageService implements DocumentStorage {
  DocumentStorageService({DocumentRootDirectoryLoader? rootDirectoryLoader})
    : _rootDirectoryLoader =
          rootDirectoryLoader ?? getApplicationDocumentsDirectory;

  final DocumentRootDirectoryLoader _rootDirectoryLoader;

  @override
  Future<StoredDocumentFiles> storePageImages(DocumentSaveDraft draft) async {
    _validatePathSegment(draft.sourceSessionId);
    final root = await _rootDirectoryLoader();
    final documentDirectory = Directory(
      path.join(root.path, 'scanly', 'documents', draft.sourceSessionId),
    );

    if (await documentDirectory.exists()) {
      throw StateError('Document directory already exists.');
    }

    try {
      final pagesDirectory = Directory(
        path.join(documentDirectory.path, 'pages'),
      );
      await pagesDirectory.create(recursive: true);

      final storedPages = <StoredDocumentPageFiles>[];
      for (final page in draft.pages) {
        storedPages.add(await _copyPage(page, pagesDirectory));
      }

      return StoredDocumentFiles(
        documentId: draft.sourceSessionId,
        directoryPath: documentDirectory.path,
        pdfPath: path.join(documentDirectory.path, 'document.pdf'),
        thumbnailPath: path.join(documentDirectory.path, 'thumbnail.jpg'),
        pages: storedPages,
      );
    } on Object {
      if (await documentDirectory.exists()) {
        await documentDirectory.delete(recursive: true);
      }
      rethrow;
    }
  }

  @override
  Future<void> deleteDocumentFiles(String directoryPath) async {
    final directory = Directory(directoryPath);
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
  }

  Future<StoredDocumentPageFiles> _copyPage(
    DocumentPageSaveDraft page,
    Directory destination,
  ) async {
    final prefix = 'page_${page.pageIndex.toString().padLeft(4, '0')}';
    final originalPath = await _copyImage(
      sourcePath: page.originalImagePath,
      destination: destination,
      fileName: '${prefix}_original',
    );
    final normalizedPath = await _copyImage(
      sourcePath: page.normalizedImagePath,
      destination: destination,
      fileName: '${prefix}_normalized',
    );
    final processedPath = await _copyImage(
      sourcePath: page.processedImagePath,
      destination: destination,
      fileName: '${prefix}_processed',
    );

    return StoredDocumentPageFiles(
      sourcePageId: page.sourcePageId,
      pageIndex: page.pageIndex,
      originalImagePath: originalPath,
      normalizedImagePath: normalizedPath,
      processedImagePath: processedPath,
    );
  }

  Future<String> _copyImage({
    required String sourcePath,
    required Directory destination,
    required String fileName,
  }) async {
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw FileSystemException('Source image does not exist.', sourcePath);
    }

    final extension = path.extension(sourcePath).toLowerCase();
    final safeExtension = extension.isEmpty ? '.jpg' : extension;
    final destinationPath = path.join(
      destination.path,
      '$fileName$safeExtension',
    );
    await source.copy(destinationPath);
    return destinationPath;
  }

  void _validatePathSegment(String value) {
    if (!RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(value)) {
      throw ArgumentError.value(value, 'documentId', 'Unsafe document id.');
    }
  }
}
