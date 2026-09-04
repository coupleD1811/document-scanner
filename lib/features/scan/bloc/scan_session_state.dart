part of 'scan_session_bloc.dart';

sealed class ScanSessionState extends Equatable {
  const ScanSessionState();

  ScanSession? get session => null;
  int get selectedPageIndex => 0;

  @override
  List<Object?> get props => [];
}

final class ScanSessionInitial extends ScanSessionState {
  const ScanSessionInitial();
}

final class ScanSessionEditing extends ScanSessionState {
  const ScanSessionEditing({
    required this.session,
    required this.selectedPageIndex,
  });

  @override
  final ScanSession session;

  @override
  final int selectedPageIndex;

  DocumentPage get selectedPage => session.pages[selectedPageIndex];

  @override
  List<Object?> get props => [session, selectedPageIndex];
}

final class ScanSessionFailure extends ScanSessionState {
  const ScanSessionFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
