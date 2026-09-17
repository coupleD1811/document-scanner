part of 'document_action_bloc.dart';

sealed class DocumentActionEvent extends Equatable {
  const DocumentActionEvent();

  @override
  List<Object?> get props => [];
}

final class DocumentOpenRequested extends DocumentActionEvent {
  const DocumentOpenRequested(this.documentId);

  final String documentId;

  @override
  List<Object?> get props => [documentId];
}

final class DocumentRenameRequested extends DocumentActionEvent {
  const DocumentRenameRequested({required this.documentId, required this.name});

  final String documentId;
  final String name;

  @override
  List<Object?> get props => [documentId, name];
}

final class DocumentShareRequested extends DocumentActionEvent {
  const DocumentShareRequested(this.documentId);

  final String documentId;

  @override
  List<Object?> get props => [documentId];
}

final class DocumentDeleteRequested extends DocumentActionEvent {
  const DocumentDeleteRequested(this.documentId);

  final String documentId;

  @override
  List<Object?> get props => [documentId];
}
