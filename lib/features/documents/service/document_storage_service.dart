import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../model/page_save_draft.dart';
import '../model/save_draft.dart';
import '../model/staged_document_deletion.dart';
import '../model/stored_document_files.dart';

typedef DocumentRootDirectoryLoader = Future<Directory> Function();

abstract interface class DocumentStorage {
  Future<StoredDocumentFiles> storePageImages(DocumentSaveDraft draft);

  Future<String> renamePdfFile({
    required String currentPath,
    required String newFileName,
  });

  Future<StagedDocumentDeletion?> stageDocumentDeletion(String directoryPath);

  Future<void> restoreStagedDocumentDeletion(StagedDocumentDeletion staged);

  Future<void> finalizeStagedDocumentDeletion(StagedDocumentDeletion staged);

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

  @override
  Future<String> renamePdfFile({
    required String currentPath,
    required String newFileName,
  }) async {
    _validatePdfFileName(newFileName);
    final currentFile = File(currentPath);
    if (!await currentFile.exists()) {
      throw FileSystemException('Document PDF does not exist.', currentPath);
    }

    final destinationPath = path.join(path.dirname(currentPath), newFileName);
    if (destinationPath == currentPath) {
      return currentPath;
    }

    final destination = File(destinationPath);
    if (await destination.exists()) {
      throw StateError('A document PDF with this name already exists.');
    }

    return (await currentFile.rename(destinationPath)).path;
  }

  @override
  Future<StagedDocumentDeletion?> stageDocumentDeletion(
    String directoryPath,
  ) async {
    final directory = Directory(directoryPath);
    if (!await directory.exists()) {
      return null;
    }

    final stagedDirectoryPath = path.join(
      directory.parent.path,
      '.deleting-${path.basename(directoryPath)}-${DateTime.now().microsecondsSinceEpoch}',
    );
    await directory.rename(stagedDirectoryPath);
    return StagedDocumentDeletion(
      originalDirectoryPath: directoryPath,
      stagedDirectoryPath: stagedDirectoryPath,
    );
  }

  @override
  Future<void> restoreStagedDocumentDeletion(
    StagedDocumentDeletion staged,
  ) async {
    final stagedDirectory = Directory(staged.stagedDirectoryPath);
    if (!await stagedDirectory.exists()) {
      return;
    }

    final originalDirectory = Directory(staged.originalDirectoryPath);
    if (await originalDirectory.exists()) {
      throw StateError('Document directory already exists during restore.');
    }
    await stagedDirectory.rename(staged.originalDirectoryPath);
  }

  @override
  Future<void> finalizeStagedDocumentDeletion(StagedDocumentDeletion staged) {
    return deleteDocumentFiles(staged.stagedDirectoryPath);
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
    if (!_isSafePathSegment(value)) {
      throw ArgumentError.value(value, 'documentId', 'Unsafe document id.');
    }
  }

  bool _isSafePathSegment(String value) {
    if (value.isEmpty) {
      return false;
    }

    for (final codeUnit in value.codeUnits) {
      final isDigit = codeUnit >= 48 && codeUnit <= 57;
      final isUppercase = codeUnit >= 65 && codeUnit <= 90;
      final isLowercase = codeUnit >= 97 && codeUnit <= 122;
      final isAllowedPunctuation =
          codeUnit == 45 || codeUnit == 46 || codeUnit == 95;
      if (!isDigit && !isUppercase && !isLowercase && !isAllowedPunctuation) {
        return false;
      }
    }
    return true;
  }

  void _validatePdfFileName(String value) {
    if (path.basename(value) != value ||
        !value.toLowerCase().endsWith('.pdf') ||
        value.trim().isEmpty) {
      throw ArgumentError.value(value, 'newFileName', 'Unsafe PDF file name.');
    }
  }
}
