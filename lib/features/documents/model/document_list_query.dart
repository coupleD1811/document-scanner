import 'package:equatable/equatable.dart';

enum DocumentListFilter { all, scans, pdfs }

enum DocumentListSort { recent, oldest }

class DocumentListQuery extends Equatable {
  const DocumentListQuery({
    this.searchTerm = '',
    this.filter = DocumentListFilter.all,
    this.sort = DocumentListSort.recent,
  });

  final String searchTerm;
  final DocumentListFilter filter;
  final DocumentListSort sort;

  DocumentListQuery copyWith({
    String? searchTerm,
    DocumentListFilter? filter,
    DocumentListSort? sort,
  }) {
    return DocumentListQuery(
      searchTerm: searchTerm ?? this.searchTerm,
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
    );
  }

  @override
  List<Object?> get props => [searchTerm, filter, sort];
}
