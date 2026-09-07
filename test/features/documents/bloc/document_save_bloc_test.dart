import 'package:flutter_test/flutter_test.dart';
import 'package:scanly/features/documents/bloc/document_save_bloc.dart';
import 'package:scanly/features/documents/model/local_document.dart';
import 'package:scanly/features/documents/model/save_draft.dart';
import 'package:scanly/features/documents/repository/document_repository.dart';
import 'package:scanly/features/scan/model/document_page.dart';
import 'package:scanly/features/scan/model/document_processing_status.dart';
import 'package:scanly/features/scan/model/scan_session.dart';

void main() {
  test('maps and saves a completed scan session', () async {
    final repository = _FakeDocumentRepository();
    final bloc = DocumentSaveBloc(repository: repository);
    addTearDown(bloc.close);

    final expectation = expectLater(
      bloc.stream,
      emitsInOrder([isA<DocumentSaveInProgress>(), isA<DocumentSaveSuccess>()]),
    );
    bloc.add(
      DocumentSaveRequested(session: _session(isReady: true), name: 'Receipt'),
    );
    await expectation;

    expect(repository.savedDraft?.name, 'Receipt');
    expect(repository.savedDraft?.pageCount, 1);
  });

  test('reports a page that has not finished processing', () async {
    final repository = _FakeDocumentRepository();
    final bloc = DocumentSaveBloc(repository: repository);
    addTearDown(bloc.close);

    final expectation = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<DocumentSaveInProgress>(),
        const DocumentSaveFailure(DocumentSaveFailureReason.pageNotReady),
      ]),
    );
    bloc.add(
      DocumentSaveRequested(session: _session(isReady: false), name: 'Receipt'),
    );
    await expectation;

    expect(repository.savedDraft, isNull);
  });
}

ScanSession _session({required bool isReady}) {
  final createdAt = DateTime.utc(2026, 9, 7);
  return ScanSession(
    id: 'scan-1',
    createdAt: createdAt,
    pages: [
      DocumentPage(
        id: 'page-1',
        originalImagePath: '/temp/original.jpg',
        normalizedImagePath: '/temp/normalized.jpg',
        processedImagePath: isReady ? '/temp/processed.jpg' : null,
        processedPixelWidth: isReady ? 1000 : null,
        processedPixelHeight: isReady ? 1400 : null,
        pixelWidth: 1200,
        pixelHeight: 1800,
        pageIndex: 0,
        processingStatus: isReady
            ? DocumentProcessingStatus.completed
            : DocumentProcessingStatus.processing,
        createdAt: createdAt,
      ),
    ],
  );
}

class _FakeDocumentRepository extends Fake implements DocumentRepository {
  DocumentSaveDraft? savedDraft;

  @override
  Future<LocalDocument> saveDocument(DocumentSaveDraft draft) async {
    savedDraft = draft;
    return LocalDocument(
      id: draft.sourceSessionId,
      name: '${draft.name}.pdf',
      pdfPath: '/stored/document.pdf',
      thumbnailPath: '/stored/thumbnail.jpg',
      pageCount: draft.pageCount,
      sizeInBytes: 1024,
      createdAt: draft.createdAt,
      updatedAt: draft.createdAt,
    );
  }
}
