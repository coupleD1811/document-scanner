part of 'document_list_bloc.dart';

sealed class DocumentListState extends Equatable {
  const DocumentListState({this.query = const DocumentListQuery()});

  final DocumentListQuery query;

  @override
  List<Object?> get props => [query];
}

final class DocumentListLoading extends DocumentListState {
  const DocumentListLoading({super.query});
}

final class DocumentListReady extends DocumentListState {
  const DocumentListReady({
    required this.documents,
    required this.recentDocuments,
    required this.totalDocumentCount,
    super.query,
  });

  final List<DocumentItem> documents;
  final List<DocumentItem> recentDocuments;
  final int totalDocumentCount;

  bool get hasDocuments => totalDocumentCount > 0;

  @override
  List<Object?> get props => [
    ...super.props,
    documents,
    recentDocuments,
    totalDocumentCount,
  ];
}

final class DocumentListFailure extends DocumentListState {
  const DocumentListFailure({super.query});
}
