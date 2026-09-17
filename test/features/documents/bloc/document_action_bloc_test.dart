import 'package:flutter_test/flutter_test.dart';
import 'package:scanly/features/documents/bloc/document_action_bloc.dart';
import 'package:scanly/features/documents/model/local_document.dart';
import 'package:scanly/features/documents/repository/document_repository.dart';
import 'package:scanly/features/documents/service/document_file_opener.dart';
import 'package:scanly/features/documents/service/document_share_service.dart';

void main() {
  late _FakeDocumentRepository repository;
  late _FakeDocumentFileOpener opener;
  late _FakeDocumentShareService shareService;
  late DocumentActionBloc bloc;

  setUp(() {
    repository = _FakeDocumentRepository(document: _document());
    opener = _FakeDocumentFileOpener();
    shareService = _FakeDocumentShareService();
    bloc = DocumentActionBloc(
      repository: repository,
      fileOpener: opener,
      shareService: shareService,
    );
  });

  tearDown(() => bloc.close());

  test('opens the persisted PDF through the file opener', () async {
    final success = bloc.stream.firstWhere(
      (state) => state is DocumentActionSuccess,
    );
    bloc.add(const DocumentOpenRequested('document-1'));
    await success;

    expect(opener.openedDocumentId, 'document-1');
    expect(
      bloc.state,
      const DocumentActionSuccess(
        action: DocumentAction.open,
        documentId: 'document-1',
        documentName: 'Receipt.pdf',
      ),
    );
  });

  test('renames a document through the repository', () async {
    final success = bloc.stream.firstWhere(
      (state) => state is DocumentActionSuccess,
    );
    bloc.add(
      const DocumentRenameRequested(
        documentId: 'document-1',
        name: 'September receipt',
      ),
    );
    await success;

    expect(repository.renamedTo, 'September receipt');
  });

  test('reports a missing document without sharing', () async {
    repository.document = null;
    final failure = bloc.stream.firstWhere(
      (state) => state is DocumentActionFailure,
    );
    bloc.add(const DocumentShareRequested('missing'));
    await failure;

    expect(shareService.sharedDocumentId, isNull);
    expect(
      bloc.state,
      const DocumentActionFailure(
        action: DocumentAction.share,
        documentId: 'missing',
        reason: DocumentActionFailureReason.notFound,
      ),
    );
  });
}

LocalDocument _document() {
  final createdAt = DateTime.utc(2026, 9, 17);
  return LocalDocument(
    id: 'document-1',
    name: 'Receipt.pdf',
    pdfPath: '/documents/document-1/Receipt.pdf',
    thumbnailPath: '/documents/document-1/thumbnail.jpg',
    pageCount: 1,
    sizeInBytes: 1024,
    createdAt: createdAt,
    updatedAt: createdAt,
  );
}

class _FakeDocumentRepository extends Fake implements DocumentRepository {
  _FakeDocumentRepository({required this.document});

  LocalDocument? document;
  String? renamedTo;

  @override
  Future<LocalDocument?> getDocument(String documentId) async => document;

  @override
  Future<void> renameDocument(String documentId, String name) async {
    renamedTo = name;
  }
}

class _FakeDocumentFileOpener implements DocumentFileOpener {
  String? openedDocumentId;

  @override
  Future<void> open(LocalDocument document) async {
    openedDocumentId = document.id;
  }
}

class _FakeDocumentShareService implements DocumentShareService {
  String? sharedDocumentId;

  @override
  Future<void> share(LocalDocument document) async {
    sharedDocumentId = document.id;
  }
}
