part of 'document_save_bloc.dart';

sealed class DocumentSaveEvent extends Equatable {
  const DocumentSaveEvent();

  @override
  List<Object?> get props => [];
}

final class DocumentSaveRequested extends DocumentSaveEvent {
  const DocumentSaveRequested({required this.session, required this.name});

  final ScanSession session;
  final String name;

  @override
  List<Object?> get props => [session, name];
}
