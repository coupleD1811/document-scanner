import 'package:equatable/equatable.dart';

import 'page_save_draft.dart';

class DocumentSaveDraft extends Equatable {
  DocumentSaveDraft({
    required this.sourceSessionId,
    required this.name,
    required List<DocumentPageSaveDraft> pages,
    required this.createdAt,
  }) : assert(sourceSessionId.isNotEmpty),
       assert(name.isNotEmpty),
       assert(pages.isNotEmpty),
       pages = List.unmodifiable(pages);

  final String sourceSessionId;
  final String name;
  final List<DocumentPageSaveDraft> pages;
  final DateTime createdAt;

  int get pageCount => pages.length;

  @override
  List<Object?> get props => [sourceSessionId, name, pages, createdAt];
}
