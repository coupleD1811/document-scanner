import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../../scan/model/document_corners.dart';
import '../../../scan/model/normalized_point.dart';
import '../../../scan/model/scan_filter.dart';
import '../../model/local_document.dart';
import '../../model/local_document_page.dart';
import '../../model/ocr_status.dart';
import '../../model/sync_status.dart';
import 'document_data_source.dart';
import 'document_tables.dart';

part 'document_database.g.dart';

@DriftDatabase(tables: [StoredDocuments, StoredDocumentPages])
class DocumentDatabase extends _$DocumentDatabase
    implements DocumentDataSource {
  DocumentDatabase([QueryExecutor? executor])
    : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  @override
  Stream<List<LocalDocument>> watchDocuments() {
    final query = select(storedDocuments)
      ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)]);
    return query.watch().map(
      (rows) => rows.map(_documentFromRow).toList(growable: false),
    );
  }

  @override
  Future<List<LocalDocument>> getDocuments() async {
    final query = select(storedDocuments)
      ..orderBy([(table) => OrderingTerm.desc(table.updatedAt)]);
    final rows = await query.get();
    return rows.map(_documentFromRow).toList(growable: false);
  }

  @override
  Future<LocalDocument?> getDocument(String documentId) async {
    final query = select(storedDocuments)
      ..where((table) => table.id.equals(documentId));
    final row = await query.getSingleOrNull();
    return row == null ? null : _documentFromRow(row);
  }

  @override
  Future<List<LocalDocumentPage>> getDocumentPages(String documentId) async {
    final query = select(storedDocumentPages)
      ..where((table) => table.documentId.equals(documentId))
      ..orderBy([(table) => OrderingTerm.asc(table.pageIndex)]);
    final rows = await query.get();
    return rows.map(_pageFromRow).toList(growable: false);
  }

  @override
  Future<void> saveDocument(
    LocalDocument document,
    List<LocalDocumentPage> pages,
  ) async {
    if (pages.length != document.pageCount ||
        pages.any((page) => page.documentId != document.id)) {
      throw ArgumentError('Document page metadata is inconsistent.');
    }

    await transaction(() async {
      await into(
        storedDocuments,
      ).insert(_documentCompanion(document), mode: InsertMode.insertOrReplace);
      await (delete(
        storedDocumentPages,
      )..where((table) => table.documentId.equals(document.id))).go();
      await batch((batch) {
        batch.insertAll(storedDocumentPages, pages.map(_pageCompanion));
      });
    });
  }

  @override
  Future<void> renameDocument({
    required String documentId,
    required String name,
    required DateTime updatedAt,
  }) async {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Name cannot be blank.');
    }

    await (update(
      storedDocuments,
    )..where((table) => table.id.equals(documentId))).write(
      StoredDocumentsCompanion(
        name: Value(normalizedName),
        updatedAt: Value(updatedAt.millisecondsSinceEpoch),
      ),
    );
  }

  @override
  Future<void> deleteDocument(String documentId) async {
    await (delete(
      storedDocuments,
    )..where((table) => table.id.equals(documentId))).go();
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'scanly_documents',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}

StoredDocumentsCompanion _documentCompanion(LocalDocument document) {
  return StoredDocumentsCompanion.insert(
    id: document.id,
    name: document.name,
    pdfPath: document.pdfPath,
    thumbnailPath: document.thumbnailPath,
    pageCount: document.pageCount,
    sizeInBytes: document.sizeInBytes,
    createdAt: document.createdAt.millisecondsSinceEpoch,
    updatedAt: document.updatedAt.millisecondsSinceEpoch,
    ocrStatus: document.ocrStatus.name,
    syncStatus: document.syncStatus.name,
  );
}

StoredDocumentPagesCompanion _pageCompanion(LocalDocumentPage page) {
  return StoredDocumentPagesCompanion.insert(
    id: page.id,
    documentId: page.documentId,
    pageIndex: page.pageIndex,
    originalImagePath: page.originalImagePath,
    normalizedImagePath: page.normalizedImagePath,
    processedImagePath: page.processedImagePath,
    originalPixelWidth: page.originalPixelWidth,
    originalPixelHeight: page.originalPixelHeight,
    processedPixelWidth: page.processedPixelWidth,
    processedPixelHeight: page.processedPixelHeight,
    topLeftX: page.corners.topLeft.x,
    topLeftY: page.corners.topLeft.y,
    topRightX: page.corners.topRight.x,
    topRightY: page.corners.topRight.y,
    bottomRightX: page.corners.bottomRight.x,
    bottomRightY: page.corners.bottomRight.y,
    bottomLeftX: page.corners.bottomLeft.x,
    bottomLeftY: page.corners.bottomLeft.y,
    cornersSource: page.corners.source.name,
    cornersConfidence: Value(page.corners.confidence),
    rotation: page.rotation,
    filter: page.filter.name,
    brightness: page.brightness,
    contrast: page.contrast,
    createdAt: page.createdAt.millisecondsSinceEpoch,
    updatedAt: page.updatedAt.millisecondsSinceEpoch,
  );
}

LocalDocument _documentFromRow(StoredDocument row) {
  return LocalDocument(
    id: row.id,
    name: row.name,
    pdfPath: row.pdfPath,
    thumbnailPath: row.thumbnailPath,
    pageCount: row.pageCount,
    sizeInBytes: row.sizeInBytes,
    createdAt: _dateTimeFromEpoch(row.createdAt),
    updatedAt: _dateTimeFromEpoch(row.updatedAt),
    ocrStatus: _enumByName(
      DocumentOcrStatus.values,
      row.ocrStatus,
      DocumentOcrStatus.notRequested,
    ),
    syncStatus: _enumByName(
      DocumentSyncStatus.values,
      row.syncStatus,
      DocumentSyncStatus.localOnly,
    ),
  );
}

LocalDocumentPage _pageFromRow(StoredDocumentPage row) {
  return LocalDocumentPage(
    id: row.id,
    documentId: row.documentId,
    pageIndex: row.pageIndex,
    originalImagePath: row.originalImagePath,
    normalizedImagePath: row.normalizedImagePath,
    processedImagePath: row.processedImagePath,
    originalPixelWidth: row.originalPixelWidth,
    originalPixelHeight: row.originalPixelHeight,
    processedPixelWidth: row.processedPixelWidth,
    processedPixelHeight: row.processedPixelHeight,
    corners: DocumentCorners(
      topLeft: NormalizedPoint(x: row.topLeftX, y: row.topLeftY),
      topRight: NormalizedPoint(x: row.topRightX, y: row.topRightY),
      bottomRight: NormalizedPoint(x: row.bottomRightX, y: row.bottomRightY),
      bottomLeft: NormalizedPoint(x: row.bottomLeftX, y: row.bottomLeftY),
      source: _enumByName(
        DocumentCornersSource.values,
        row.cornersSource,
        DocumentCornersSource.fullImage,
      ),
      confidence: row.cornersConfidence,
    ),
    rotation: row.rotation,
    filter: _enumByName(ScanFilter.values, row.filter, ScanFilter.original),
    brightness: row.brightness,
    contrast: row.contrast,
    createdAt: _dateTimeFromEpoch(row.createdAt),
    updatedAt: _dateTimeFromEpoch(row.updatedAt),
  );
}

T _enumByName<T extends Enum>(List<T> values, String name, T fallback) {
  return values.cast<T?>().firstWhere(
        (value) => value?.name == name,
        orElse: () => null,
      ) ??
      fallback;
}

DateTime _dateTimeFromEpoch(int milliseconds) {
  return DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);
}
