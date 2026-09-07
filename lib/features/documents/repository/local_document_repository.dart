import 'package:path/path.dart' as path;

import '../model/local_document.dart';
import '../model/local_document_page.dart';
import '../model/ocr_status.dart';
import '../model/save_draft.dart';
import '../model/stored_document_files.dart';
import '../model/sync_status.dart';
import '../service/database/document_data_source.dart';
import '../service/document_export_service.dart';
import '../service/document_storage_service.dart';
import 'document_repository.dart';

typedef DocumentRepositoryClock = DateTime Function();

class LocalDocumentRepository implements DocumentRepository {
  LocalDocumentRepository({
    required DocumentDataSource dataSource,
    required DocumentStorage storage,
    required DocumentExportService exporter,
    DocumentRepositoryClock? clock,
  }) : _dataSource = dataSource,
       _storage = storage,
       _exporter = exporter,
       _clock = clock ?? DateTime.now;

  final DocumentDataSource _dataSource;
  final DocumentStorage _storage;
  final DocumentExportService _exporter;
  final DocumentRepositoryClock _clock;

  @override
  Future<LocalDocument> saveDocument(DocumentSaveDraft draft) async {
    StoredDocumentFiles? storedFiles;
    try {
      storedFiles = await _storage.storePageImages(draft);
      final export = await _exporter.export(storedFiles);
      final createdAt = draft.createdAt.toUtc();
      final currentTime = _clock().toUtc();
      final updatedAt = currentTime.isBefore(createdAt)
          ? createdAt
          : currentTime;
      final document = LocalDocument(
        id: draft.sourceSessionId,
        name: _pdfFileName(draft.name),
        pdfPath: storedFiles.pdfPath,
        thumbnailPath: storedFiles.thumbnailPath,
        pageCount: draft.pageCount,
        sizeInBytes: export.pdfSizeInBytes,
        createdAt: createdAt,
        updatedAt: updatedAt,
        ocrStatus: DocumentOcrStatus.notRequested,
        syncStatus: DocumentSyncStatus.localOnly,
      );
      final pages = _createPages(
        document: document,
        draft: draft,
        files: storedFiles,
        updatedAt: updatedAt,
      );
      await _dataSource.saveDocument(document, pages);
      return document;
    } on Object {
      if (storedFiles != null) {
        await _storage.deleteDocumentFiles(storedFiles.directoryPath);
      }
      rethrow;
    }
  }

  @override
  Stream<List<LocalDocument>> watchDocuments() {
    return _dataSource.watchDocuments();
  }

  @override
  Future<List<LocalDocument>> getDocuments() {
    return _dataSource.getDocuments();
  }

  @override
  Future<List<LocalDocumentPage>> getDocumentPages(String documentId) {
    return _dataSource.getDocumentPages(documentId);
  }

  @override
  Future<void> renameDocument(String documentId, String name) {
    return _dataSource.renameDocument(
      documentId: documentId,
      name: _pdfFileName(name),
      updatedAt: _clock().toUtc(),
    );
  }

  @override
  Future<void> deleteDocument(String documentId) async {
    final document = await _dataSource.getDocument(documentId);
    if (document == null) {
      return;
    }

    await _dataSource.deleteDocument(documentId);
    await _storage.deleteDocumentFiles(path.dirname(document.pdfPath));
  }

  @override
  Future<void> close() {
    return _dataSource.close();
  }

  List<LocalDocumentPage> _createPages({
    required LocalDocument document,
    required DocumentSaveDraft draft,
    required StoredDocumentFiles files,
    required DateTime updatedAt,
  }) {
    final storedBySourceId = {
      for (final page in files.pages) page.sourcePageId: page,
    };

    return [
      for (final draftPage in draft.pages)
        LocalDocumentPage(
          id: draftPage.sourcePageId,
          documentId: document.id,
          pageIndex: draftPage.pageIndex,
          originalImagePath:
              storedBySourceId[draftPage.sourcePageId]!.originalImagePath,
          normalizedImagePath:
              storedBySourceId[draftPage.sourcePageId]!.normalizedImagePath,
          processedImagePath:
              storedBySourceId[draftPage.sourcePageId]!.processedImagePath,
          originalPixelWidth: draftPage.originalPixelWidth,
          originalPixelHeight: draftPage.originalPixelHeight,
          processedPixelWidth: draftPage.processedPixelWidth,
          processedPixelHeight: draftPage.processedPixelHeight,
          corners: draftPage.corners,
          rotation: draftPage.rotation,
          filter: draftPage.filter,
          brightness: draftPage.brightness,
          contrast: draftPage.contrast,
          createdAt: draftPage.createdAt.toUtc(),
          updatedAt: updatedAt,
        ),
    ];
  }
}

String _pdfFileName(String name) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) {
    throw ArgumentError.value(name, 'name', 'Name cannot be blank.');
  }
  return trimmed.toLowerCase().endsWith('.pdf') ? trimmed : '$trimmed.pdf';
}
