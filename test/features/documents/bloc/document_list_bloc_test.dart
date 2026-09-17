import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:scanly/features/documents/bloc/document_list_bloc.dart';
import 'package:scanly/features/documents/model/document_list_query.dart';
import 'package:scanly/features/documents/model/local_document.dart';
import 'package:scanly/features/documents/repository/document_repository.dart';

void main() {
  late StreamController<List<LocalDocument>> documentsController;
  late DocumentListBloc bloc;

  setUp(() {
    documentsController = StreamController<List<LocalDocument>>();
    bloc = DocumentListBloc(
      repository: _WatchingDocumentRepository(documentsController.stream),
    );
  });

  tearDown(() async {
    await bloc.close();
    await documentsController.close();
  });

  test('shows recent documents from the repository stream', () async {
    final ready = bloc.stream.firstWhere((state) => state is DocumentListReady);
    documentsController.add([
      _document(id: 'old', name: 'Old scan.pdf', day: 1),
      _document(id: 'new', name: 'New scan.pdf', day: 2),
    ]);

    await ready;

    final state = bloc.state as DocumentListReady;
    expect(state.documents.map((document) => document.id), ['new', 'old']);
    expect(state.recentDocuments.map((document) => document.id), [
      'new',
      'old',
    ]);
  });

  test('filters by name and changes the updated date order', () async {
    final firstReady = bloc.stream.firstWhere(
      (state) => state is DocumentListReady,
    );
    documentsController.add([
      _document(id: 'receipt', name: 'Receipt.pdf', day: 1),
      _document(id: 'contract', name: 'Contract.pdf', day: 2),
    ]);
    await firstReady;

    final searched = bloc.stream.firstWhere(
      (state) =>
          state is DocumentListReady && state.query.searchTerm == 'receipt',
    );
    bloc.add(const DocumentListSearchChanged(' receipt '));
    await searched;

    expect(
      (bloc.state as DocumentListReady).documents.single.name,
      'Receipt.pdf',
    );

    final sorted = bloc.stream.firstWhere(
      (state) =>
          state is DocumentListReady &&
          state.query.sort == DocumentListSort.oldest,
    );
    bloc.add(const DocumentListSortChanged(DocumentListSort.oldest));
    await sorted;

    expect((bloc.state as DocumentListReady).documents.single.id, 'receipt');
  });

  test('returns no matches for PDFs until PDF import is available', () async {
    final firstReady = bloc.stream.firstWhere(
      (state) => state is DocumentListReady,
    );
    documentsController.add([_document(id: 'scan', name: 'Scan.pdf', day: 1)]);
    await firstReady;

    final filtered = bloc.stream.firstWhere(
      (state) =>
          state is DocumentListReady &&
          state.query.filter == DocumentListFilter.pdfs,
    );
    bloc.add(const DocumentListFilterChanged(DocumentListFilter.pdfs));
    await filtered;

    final state = bloc.state as DocumentListReady;
    expect(state.totalDocumentCount, 1);
    expect(state.documents, isEmpty);
  });
}

LocalDocument _document({
  required String id,
  required String name,
  required int day,
}) {
  final timestamp = DateTime.utc(2026, 9, day);
  return LocalDocument(
    id: id,
    name: name,
    pdfPath: '/documents/$id/document.pdf',
    thumbnailPath: '/documents/$id/thumbnail.jpg',
    pageCount: 1,
    sizeInBytes: 1024,
    createdAt: timestamp,
    updatedAt: timestamp,
  );
}

class _WatchingDocumentRepository extends Fake implements DocumentRepository {
  _WatchingDocumentRepository(this.documents);

  final Stream<List<LocalDocument>> documents;

  @override
  Stream<List<LocalDocument>> watchDocuments() => documents;
}
