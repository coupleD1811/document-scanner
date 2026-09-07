import 'package:flutter_test/flutter_test.dart';
import 'package:scanly/features/documents/service/scan_session_document_mapper.dart';
import 'package:scanly/features/scan/model/document_page.dart';
import 'package:scanly/features/scan/model/document_processing_status.dart';
import 'package:scanly/features/scan/model/scan_filter.dart';
import 'package:scanly/features/scan/model/scan_session.dart';

void main() {
  const mapper = ScanSessionDocumentMapper();
  final createdAt = DateTime.utc(2026, 9, 7, 10);

  test('maps a completed scan session into an immutable save draft', () {
    final session = ScanSession(
      id: 'scan-1',
      pages: [
        _page(
          id: 'page-a',
          pageIndex: 4,
          createdAt: createdAt,
          rotation: 90,
          filter: ScanFilter.grayscale,
          brightness: 20,
          contrast: -10,
        ),
        _page(id: 'page-b', pageIndex: 2, createdAt: createdAt),
      ],
      createdAt: createdAt,
    );

    final draft = mapper.map(session: session, name: '  My document  ');

    expect(draft.sourceSessionId, 'scan-1');
    expect(draft.name, 'My document');
    expect(draft.createdAt, createdAt);
    expect(draft.pageCount, 2);
    expect(draft.pages.first.sourcePageId, 'page-a');
    expect(draft.pages.first.pageIndex, 0);
    expect(draft.pages.first.rotation, 90);
    expect(draft.pages.first.filter, ScanFilter.grayscale);
    expect(draft.pages.first.brightness, 20);
    expect(draft.pages.first.contrast, -10);
    expect(draft.pages.last.sourcePageId, 'page-b');
    expect(draft.pages.last.pageIndex, 1);
    expect(() => draft.pages.add(draft.pages.first), throwsUnsupportedError);
  });

  test('rejects a blank document name', () {
    final session = ScanSession(
      id: 'scan-1',
      pages: [_page(id: 'page-1', pageIndex: 0, createdAt: createdAt)],
      createdAt: createdAt,
    );

    expect(
      () => mapper.map(session: session, name: '   '),
      throwsA(
        isA<ScanSessionDocumentMappingException>().having(
          (error) => error.failure,
          'failure',
          ScanSessionDocumentMappingFailure.invalidName,
        ),
      ),
    );
  });

  test('rejects a session without pages', () {
    final session = ScanSession(
      id: 'scan-1',
      pages: const [],
      createdAt: createdAt,
    );

    expect(
      () => mapper.map(session: session, name: 'Document'),
      throwsA(
        isA<ScanSessionDocumentMappingException>().having(
          (error) => error.failure,
          'failure',
          ScanSessionDocumentMappingFailure.emptySession,
        ),
      ),
    );
  });

  test('identifies the page that is not ready to save', () {
    final session = ScanSession(
      id: 'scan-1',
      pages: [
        _page(
          id: 'page-pending',
          pageIndex: 0,
          createdAt: createdAt,
          isProcessed: false,
        ),
      ],
      createdAt: createdAt,
    );

    expect(
      () => mapper.map(session: session, name: 'Document'),
      throwsA(
        isA<ScanSessionDocumentMappingException>()
            .having(
              (error) => error.failure,
              'failure',
              ScanSessionDocumentMappingFailure.pageNotReady,
            )
            .having((error) => error.pageId, 'pageId', 'page-pending'),
      ),
    );
  });
}

DocumentPage _page({
  required String id,
  required int pageIndex,
  required DateTime createdAt,
  bool isProcessed = true,
  int rotation = 0,
  ScanFilter filter = ScanFilter.original,
  int brightness = 0,
  int contrast = 0,
}) {
  return DocumentPage(
    id: id,
    originalImagePath: '/tmp/$id-original.jpg',
    normalizedImagePath: '/tmp/$id-normalized.jpg',
    processedImagePath: isProcessed ? '/tmp/$id-processed.jpg' : null,
    processedPixelWidth: isProcessed ? 1200 : null,
    processedPixelHeight: isProcessed ? 1800 : null,
    pixelWidth: 2400,
    pixelHeight: 3600,
    pageIndex: pageIndex,
    processingStatus: isProcessed
        ? DocumentProcessingStatus.completed
        : DocumentProcessingStatus.processing,
    rotation: rotation,
    filter: filter,
    brightness: brightness,
    contrast: contrast,
    createdAt: createdAt,
  );
}
