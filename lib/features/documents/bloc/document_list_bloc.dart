import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/document_item.dart';
import '../model/document_list_query.dart';
import '../model/local_document.dart';
import '../repository/document_repository.dart';

part 'document_list_event.dart';
part 'document_list_state.dart';

class DocumentListBloc extends Bloc<DocumentListEvent, DocumentListState> {
  DocumentListBloc({required DocumentRepository repository})
    : _repository = repository,
      super(const DocumentListLoading()) {
    on<DocumentListSubscriptionRequested>(_onSubscriptionRequested);
    on<DocumentListDocumentsUpdated>(_onDocumentsUpdated);
    on<DocumentListSubscriptionFailed>(_onSubscriptionFailed);
    on<DocumentListSearchChanged>(_onSearchChanged);
    on<DocumentListFilterChanged>(_onFilterChanged);
    on<DocumentListSortChanged>(_onSortChanged);

    add(const DocumentListSubscriptionRequested());
  }

  final DocumentRepository _repository;
  StreamSubscription<List<LocalDocument>>? _documentsSubscription;
  List<LocalDocument> _allDocuments = const [];
  DocumentListQuery _query = const DocumentListQuery();

  Future<void> _onSubscriptionRequested(
    DocumentListSubscriptionRequested event,
    Emitter<DocumentListState> emit,
  ) async {
    await _documentsSubscription?.cancel();
    emit(DocumentListLoading(query: _query));
    _documentsSubscription = _repository.watchDocuments().listen(
      (documents) => add(DocumentListDocumentsUpdated(documents)),
      onError: (_, __) => add(const DocumentListSubscriptionFailed()),
    );
  }

  void _onDocumentsUpdated(
    DocumentListDocumentsUpdated event,
    Emitter<DocumentListState> emit,
  ) {
    _allDocuments = List.unmodifiable(event.documents);
    emit(_readyState());
  }

  void _onSubscriptionFailed(
    DocumentListSubscriptionFailed event,
    Emitter<DocumentListState> emit,
  ) {
    emit(DocumentListFailure(query: _query));
  }

  void _onSearchChanged(
    DocumentListSearchChanged event,
    Emitter<DocumentListState> emit,
  ) {
    _query = _query.copyWith(searchTerm: event.searchTerm.trim());
    _emitCurrentResult(emit);
  }

  void _onFilterChanged(
    DocumentListFilterChanged event,
    Emitter<DocumentListState> emit,
  ) {
    _query = _query.copyWith(filter: event.filter);
    _emitCurrentResult(emit);
  }

  void _onSortChanged(
    DocumentListSortChanged event,
    Emitter<DocumentListState> emit,
  ) {
    _query = _query.copyWith(sort: event.sort);
    _emitCurrentResult(emit);
  }

  void _emitCurrentResult(Emitter<DocumentListState> emit) {
    if (state is DocumentListLoading || state is DocumentListFailure) {
      return;
    }
    emit(_readyState());
  }

  DocumentListReady _readyState() {
    final allItems = _allDocuments
        .map(DocumentItem.fromLocalDocument)
        .toList(growable: false);
    final normalizedSearchTerm = _query.searchTerm.toLowerCase();
    final documents = allItems.where((document) {
      final matchesSearch =
          normalizedSearchTerm.isEmpty ||
          document.name.toLowerCase().contains(normalizedSearchTerm);
      final matchesFilter = switch (_query.filter) {
        DocumentListFilter.all => true,
        DocumentListFilter.scans => document.type == DocumentType.scan,
        DocumentListFilter.pdfs => document.type == DocumentType.pdf,
      };
      return matchesSearch && matchesFilter;
    }).toList();

    documents.sort((first, second) {
      final comparison = first.updatedAt.compareTo(second.updatedAt);
      return _query.sort == DocumentListSort.recent ? -comparison : comparison;
    });

    final recentDocuments = allItems.toList()
      ..sort((first, second) => second.updatedAt.compareTo(first.updatedAt));

    return DocumentListReady(
      documents: List.unmodifiable(documents),
      recentDocuments: List.unmodifiable(recentDocuments.take(3)),
      totalDocumentCount: _allDocuments.length,
      query: _query,
    );
  }

  @override
  Future<void> close() async {
    await _documentsSubscription?.cancel();
    return super.close();
  }
}
