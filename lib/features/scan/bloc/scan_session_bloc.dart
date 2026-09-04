import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/document_page.dart';
import '../model/scan_session.dart';

part 'scan_session_event.dart';
part 'scan_session_state.dart';

typedef ScanSessionClock = DateTime Function();

class ScanSessionBloc extends Bloc<ScanSessionEvent, ScanSessionState> {
  ScanSessionBloc({ScanSessionClock? clock})
    : _clock = clock ?? DateTime.now,
      super(const ScanSessionInitial()) {
    on<ScanSessionCleared>(_onCleared);
    on<ScanSessionPageAdded>(_onPageAdded);
    on<ScanSessionPageSelected>(_onPageSelected);
    on<ScanSessionPageRemoved>(_onPageRemoved);
    on<ScanSessionPagesReordered>(_onPagesReordered);
  }

  final ScanSessionClock _clock;
  int _nextId = 0;

  void _onCleared(ScanSessionCleared event, Emitter<ScanSessionState> emit) {
    emit(const ScanSessionInitial());
  }

  void _onPageAdded(
    ScanSessionPageAdded event,
    Emitter<ScanSessionState> emit,
  ) {
    final now = _clock();
    final currentSession = state.session;
    final pages = [...?currentSession?.pages];
    final page = DocumentPage(
      id: 'page-${now.microsecondsSinceEpoch}-${_nextId++}',
      originalImagePath: event.imagePath,
      pageIndex: pages.length,
      createdAt: now,
    );
    pages.add(page);

    emit(
      ScanSessionEditing(
        session: ScanSession(
          id: currentSession?.id ?? 'scan-${now.microsecondsSinceEpoch}',
          pages: List.unmodifiable(pages),
          createdAt: currentSession?.createdAt ?? now,
        ),
        selectedPageIndex: pages.length - 1,
      ),
    );
  }

  void _onPageSelected(
    ScanSessionPageSelected event,
    Emitter<ScanSessionState> emit,
  ) {
    final session = state.session;
    if (session == null ||
        event.pageIndex < 0 ||
        event.pageIndex >= session.pages.length) {
      return;
    }

    emit(
      ScanSessionEditing(session: session, selectedPageIndex: event.pageIndex),
    );
  }

  void _onPageRemoved(
    ScanSessionPageRemoved event,
    Emitter<ScanSessionState> emit,
  ) {
    final session = state.session;
    if (session == null) {
      return;
    }

    final pages = session.pages
        .where((page) => page.id != event.pageId)
        .toList(growable: false);
    if (pages.length == session.pages.length) {
      return;
    }
    if (pages.isEmpty) {
      emit(const ScanSessionInitial());
      return;
    }

    final normalizedPages = _normalizePageIndexes(pages);
    final nextSelectedIndex = state.selectedPageIndex.clamp(
      0,
      normalizedPages.length - 1,
    );
    emit(
      ScanSessionEditing(
        session: session.copyWith(pages: normalizedPages),
        selectedPageIndex: nextSelectedIndex,
      ),
    );
  }

  void _onPagesReordered(
    ScanSessionPagesReordered event,
    Emitter<ScanSessionState> emit,
  ) {
    final session = state.session;
    if (session == null ||
        event.oldIndex < 0 ||
        event.oldIndex >= session.pages.length ||
        event.newIndex < 0 ||
        event.newIndex >= session.pages.length) {
      return;
    }

    if (event.newIndex == event.oldIndex) {
      return;
    }

    final pages = [...session.pages];
    final movedPage = pages.removeAt(event.oldIndex);
    pages.insert(event.newIndex, movedPage);
    final normalizedPages = _normalizePageIndexes(pages);

    emit(
      ScanSessionEditing(
        session: session.copyWith(pages: normalizedPages),
        selectedPageIndex: event.newIndex,
      ),
    );
  }

  List<DocumentPage> _normalizePageIndexes(List<DocumentPage> pages) {
    return List.unmodifiable([
      for (var index = 0; index < pages.length; index += 1)
        pages[index].copyWith(pageIndex: index),
    ]);
  }
}
