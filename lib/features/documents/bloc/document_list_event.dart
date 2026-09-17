part of 'document_list_bloc.dart';

sealed class DocumentListEvent extends Equatable {
  const DocumentListEvent();

  @override
  List<Object?> get props => [];
}

final class DocumentListSubscriptionRequested extends DocumentListEvent {
  const DocumentListSubscriptionRequested();
}

final class DocumentListDocumentsUpdated extends DocumentListEvent {
  const DocumentListDocumentsUpdated(this.documents);

  final List<LocalDocument> documents;

  @override
  List<Object?> get props => [documents];
}

final class DocumentListSubscriptionFailed extends DocumentListEvent {
  const DocumentListSubscriptionFailed();
}

final class DocumentListSearchChanged extends DocumentListEvent {
  const DocumentListSearchChanged(this.searchTerm);

  final String searchTerm;

  @override
  List<Object?> get props => [searchTerm];
}

final class DocumentListFilterChanged extends DocumentListEvent {
  const DocumentListFilterChanged(this.filter);

  final DocumentListFilter filter;

  @override
  List<Object?> get props => [filter];
}

final class DocumentListSortChanged extends DocumentListEvent {
  const DocumentListSortChanged(this.sort);

  final DocumentListSort sort;

  @override
  List<Object?> get props => [sort];
}
