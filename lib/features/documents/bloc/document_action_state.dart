part of 'document_action_bloc.dart';

enum DocumentAction { open, rename, share, delete }

enum DocumentActionFailureReason {
  invalidName,
  notFound,
  fileUnavailable,
  unexpected,
}

sealed class DocumentActionState extends Equatable {
  const DocumentActionState();

  @override
  List<Object?> get props => [];
}

final class DocumentActionInitial extends DocumentActionState {
  const DocumentActionInitial();
}

final class DocumentActionInProgress extends DocumentActionState {
  const DocumentActionInProgress({
    required this.action,
    required this.documentId,
  });

  final DocumentAction action;
  final String documentId;

  @override
  List<Object?> get props => [action, documentId];
}

final class DocumentActionSuccess extends DocumentActionState {
  const DocumentActionSuccess({
    required this.action,
    required this.documentId,
    required this.documentName,
  });

  final DocumentAction action;
  final String documentId;
  final String documentName;

  @override
  List<Object?> get props => [action, documentId, documentName];
}

final class DocumentActionFailure extends DocumentActionState {
  const DocumentActionFailure({
    required this.action,
    required this.documentId,
    required this.reason,
  });

  final DocumentAction action;
  final String documentId;
  final DocumentActionFailureReason reason;

  @override
  List<Object?> get props => [action, documentId, reason];
}
