import 'package:equatable/equatable.dart';

import 'document_page.dart';

class ScanSession extends Equatable {
  ScanSession({
    required this.id,
    required List<DocumentPage> pages,
    required this.createdAt,
  }) : pages = List.unmodifiable(pages);

  final String id;
  final List<DocumentPage> pages;
  final DateTime createdAt;

  ScanSession copyWith({
    String? id,
    List<DocumentPage>? pages,
    DateTime? createdAt,
  }) {
    return ScanSession(
      id: id ?? this.id,
      pages: pages ?? this.pages,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, pages, createdAt];
}
