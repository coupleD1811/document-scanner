import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scanly/features/documents/model/document_export_result.dart';
import 'package:scanly/features/documents/model/page_save_draft.dart';
import 'package:scanly/features/documents/model/save_draft.dart';
import 'package:scanly/features/documents/model/staged_document_deletion.dart';
import 'package:scanly/features/documents/model/stored_document_files.dart';
import 'package:scanly/features/documents/repository/local_document_repository.dart';
import 'package:scanly/features/documents/service/database/document_database.dart';
import 'package:scanly/features/documents/service/document_export_service.dart';
import 'package:scanly/features/documents/service/document_storage_service.dart';
import 'package:scanly/features/scan/model/document_corners.dart';
import 'package:scanly/features/scan/model/scan_filter.dart';

void main() {
  late DocumentDatabase database;
  late _FakeStorage storage;
  late _FakeExporter exporter;
  late LocalDocumentRepository repository;

  setUp(() {
    database = DocumentDatabase(NativeDatabase.memory());
    storage = _FakeStorage(_storedFiles());
    exporter = _FakeExporter();
    repository = LocalDocumentRepository(
      dataSource: database,
      storage: storage,
      exporter: exporter,
      clock: () => DateTime.utc(2026, 9, 7, 10),
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('saves exported files and complete page metadata', () async {
    final draft = _draft();

    final document = await repository.saveDocument(draft);

    expect(document.name, 'My scan.pdf');
    expect(document.sizeInBytes, 8192);
    expect((await repository.getDocuments()).single, document);
    final pages = await repository.getDocumentPages(document.id);
    expect(pages.single.processedImagePath, '/stored/page_processed.jpg');
    expect(pages.single.filter, ScanFilter.grayscale);
    expect(storage.deletedDirectories, isEmpty);
  });

  test('deletes stored files when exporting fails', () async {
    exporter.error = const FormatException('Invalid image');

    await expectLater(
      repository.saveDocument(_draft()),
      throwsA(isA<FormatException>()),
    );

    expect(storage.deletedDirectories, ['/stored']);
    expect(await repository.getDocuments(), isEmpty);
  });

  test('renames the PDF file and its persisted metadata together', () async {
    final document = await repository.saveDocument(_draft());

    await repository.renameDocument(document.id, 'Receipt September');

    final renamed = (await repository.getDocuments()).single;
    expect(renamed.name, 'Receipt September.pdf');
    expect(renamed.pdfPath, '/stored/Receipt September.pdf');
  });

  test(
    'stages files before deleting their metadata and finalizes afterwards',
    () async {
      final document = await repository.saveDocument(_draft());

      await repository.deleteDocument(document.id);

      expect(await repository.getDocuments(), isEmpty);
      expect(storage.deletedDirectories, ['/stored.deleting']);
    },
  );

  test('restores files and metadata when finalizing deletion fails', () async {
    final document = await repository.saveDocument(_draft());
    storage.finalizeError = StateError('Disk temporarily unavailable');

    await expectLater(
      repository.deleteDocument(document.id),
      throwsA(isA<StateError>()),
    );

    expect((await repository.getDocuments()).single, document);
    expect(storage.restoredStagedDeletion, isTrue);
  });
}

DocumentSaveDraft _draft() {
  final createdAt = DateTime.utc(2026, 9, 7, 9);
  return DocumentSaveDraft(
    sourceSessionId: 'scan-1',
    name: 'My scan',
    createdAt: createdAt,
    pages: [
      DocumentPageSaveDraft(
        sourcePageId: 'page-1',
        pageIndex: 0,
        originalImagePath: '/temp/original.jpg',
        normalizedImagePath: '/temp/normalized.jpg',
        processedImagePath: '/temp/processed.jpg',
        originalPixelWidth: 1200,
        originalPixelHeight: 1800,
        processedPixelWidth: 1000,
        processedPixelHeight: 1400,
        corners: DocumentCorners.fullImage,
        rotation: 90,
        filter: ScanFilter.grayscale,
        brightness: 12,
        contrast: -8,
        createdAt: createdAt,
      ),
    ],
  );
}

StoredDocumentFiles _storedFiles() {
  return StoredDocumentFiles(
    documentId: 'scan-1',
    directoryPath: '/stored',
    pdfPath: '/stored/document.pdf',
    thumbnailPath: '/stored/thumbnail.jpg',
    pages: const [
      StoredDocumentPageFiles(
        sourcePageId: 'page-1',
        pageIndex: 0,
        originalImagePath: '/stored/page_original.jpg',
        normalizedImagePath: '/stored/page_normalized.jpg',
        processedImagePath: '/stored/page_processed.jpg',
      ),
    ],
  );
}

class _FakeStorage implements DocumentStorage {
  _FakeStorage(this.result);

  final StoredDocumentFiles result;
  final List<String> deletedDirectories = [];
  Object? finalizeError;
  bool restoredStagedDeletion = false;

  @override
  Future<StoredDocumentFiles> storePageImages(DocumentSaveDraft draft) async {
    return result;
  }

  @override
  Future<void> deleteDocumentFiles(String directoryPath) async {
    deletedDirectories.add(directoryPath);
  }

  @override
  Future<void> finalizeStagedDocumentDeletion(
    StagedDocumentDeletion staged,
  ) async {
    final error = finalizeError;
    if (error != null) {
      throw error;
    }
    deletedDirectories.add(staged.stagedDirectoryPath);
  }

  @override
  Future<String> renamePdfFile({
    required String currentPath,
    required String newFileName,
  }) async {
    return '/stored/$newFileName';
  }

  @override
  Future<void> restoreStagedDocumentDeletion(
    StagedDocumentDeletion staged,
  ) async {
    restoredStagedDeletion = true;
  }

  @override
  Future<StagedDocumentDeletion?> stageDocumentDeletion(
    String directoryPath,
  ) async {
    return StagedDocumentDeletion(
      originalDirectoryPath: directoryPath,
      stagedDirectoryPath: '$directoryPath.deleting',
    );
  }
}

class _FakeExporter implements DocumentExportService {
  Object? error;

  @override
  Future<DocumentExportResult> export(StoredDocumentFiles files) async {
    final exportError = error;
    if (exportError != null) {
      throw exportError;
    }
    return const DocumentExportResult(pdfSizeInBytes: 8192);
  }
}
