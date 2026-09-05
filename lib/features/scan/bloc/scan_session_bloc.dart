import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/document_page.dart';
import '../model/document_corners.dart';
import '../model/document_processing_status.dart';
import '../model/normalized_document_image.dart';
import '../model/scan_session.dart';
import '../service/document_perspective_corrector.dart';

part 'scan_session_event.dart';
part 'scan_session_state.dart';

typedef ScanSessionClock = DateTime Function();

class ScanSessionBloc extends Bloc<ScanSessionEvent, ScanSessionState> {
  ScanSessionBloc({
    ScanSessionClock? clock,
    DocumentPerspectiveCorrector? perspectiveCorrector,
  }) : _clock = clock ?? DateTime.now,
       _perspectiveCorrector =
           perspectiveCorrector ?? LocalDocumentPerspectiveCorrector(),
       super(const ScanSessionInitial()) {
    on<ScanSessionCleared>(_onCleared);
    on<ScanSessionPageAdded>(_onPageAdded);
    on<ScanSessionPageSelected>(_onPageSelected);
    on<ScanSessionPageRemoved>(_onPageRemoved);
    on<ScanSessionPagesReordered>(_onPagesReordered);
    on<ScanSessionPageCornersUpdated>(_onPageCornersUpdated);
    on<ScanSessionPageRotationRequested>(_onPageRotationRequested);
    on<ScanSessionPageProcessingRequested>(_onPageProcessingRequested);
  }

  final ScanSessionClock _clock;
  final DocumentPerspectiveCorrector _perspectiveCorrector;
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
      originalImagePath: event.image.originalImagePath,
      normalizedImagePath: event.image.normalizedImagePath,
      pixelWidth: event.image.pixelWidth,
      pixelHeight: event.image.pixelHeight,
      pageIndex: pages.length,
      corners: event.image.corners,
      detectedCorners: event.image.detectedCorners,
      edgeDetectionStatus: event.image.edgeDetectionStatus,
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
    add(ScanSessionPageProcessingRequested(page.id));
  }

  void _onPageCornersUpdated(
    ScanSessionPageCornersUpdated event,
    Emitter<ScanSessionState> emit,
  ) {
    final session = state.session;
    if (session == null || !event.corners.isUsable) {
      return;
    }

    final pageIndex = session.pages.indexWhere(
      (page) => page.id == event.pageId,
    );
    if (pageIndex == -1) {
      return;
    }

    final pages = [...session.pages];
    pages[pageIndex] = pages[pageIndex].copyWith(
      corners: event.corners,
      clearProcessedImagePath: true,
      processingStatus: DocumentProcessingStatus.notStarted,
    );
    emit(
      ScanSessionEditing(
        session: session.copyWith(pages: List.unmodifiable(pages)),
        selectedPageIndex: pageIndex,
      ),
    );
    add(ScanSessionPageProcessingRequested(event.pageId));
  }

  void _onPageRotationRequested(
    ScanSessionPageRotationRequested event,
    Emitter<ScanSessionState> emit,
  ) {
    final session = state.session;
    if (session == null) {
      return;
    }

    final pageIndex = session.pages.indexWhere(
      (page) => page.id == event.pageId,
    );
    if (pageIndex == -1) {
      return;
    }

    final page = session.pages[pageIndex];
    if (page.processingStatus == DocumentProcessingStatus.processing) {
      return;
    }

    final rotation = (page.rotation + event.quarterTurns * 90) % 360;
    final pages = [...session.pages];
    pages[pageIndex] = page.copyWith(
      rotation: rotation,
      clearProcessedImagePath: true,
      processingStatus: DocumentProcessingStatus.notStarted,
    );
    emit(
      ScanSessionEditing(
        session: session.copyWith(pages: List.unmodifiable(pages)),
        selectedPageIndex: pageIndex,
      ),
    );
    add(ScanSessionPageProcessingRequested(event.pageId));
  }

  Future<void> _onPageProcessingRequested(
    ScanSessionPageProcessingRequested event,
    Emitter<ScanSessionState> emit,
  ) async {
    final session = state.session;
    if (session == null) {
      return;
    }

    final pageIndex = session.pages.indexWhere(
      (page) => page.id == event.pageId,
    );
    if (pageIndex == -1) {
      return;
    }
    final page = session.pages[pageIndex];
    if (!page.corners.isUsable ||
        page.processingStatus == DocumentProcessingStatus.processing) {
      return;
    }

    final requestedCorners = page.corners;
    final requestedRotation = page.rotation;
    final processingPages = [...session.pages];
    processingPages[pageIndex] = page.copyWith(
      clearProcessedImagePath: true,
      processingStatus: DocumentProcessingStatus.processing,
    );
    emit(
      ScanSessionEditing(
        session: session.copyWith(pages: List.unmodifiable(processingPages)),
        selectedPageIndex: state.selectedPageIndex,
      ),
    );

    try {
      final result = await _perspectiveCorrector.correct(
        normalizedImagePath: page.normalizedImagePath,
        corners: requestedCorners,
        rotationDegrees: requestedRotation,
      );
      final currentSession = state.session;
      if (currentSession == null) {
        return;
      }
      final currentIndex = currentSession.pages.indexWhere(
        (currentPage) => currentPage.id == event.pageId,
      );
      if (currentIndex == -1 ||
          currentSession.pages[currentIndex].corners != requestedCorners ||
          currentSession.pages[currentIndex].rotation != requestedRotation) {
        return;
      }

      final completedPages = [...currentSession.pages];
      completedPages[currentIndex] = completedPages[currentIndex].copyWith(
        processedImagePath: result.imagePath,
        processedPixelWidth: result.pixelWidth,
        processedPixelHeight: result.pixelHeight,
        processingStatus: DocumentProcessingStatus.completed,
      );
      emit(
        ScanSessionEditing(
          session: currentSession.copyWith(
            pages: List.unmodifiable(completedPages),
          ),
          selectedPageIndex: state.selectedPageIndex,
        ),
      );
    } on Object {
      final currentSession = state.session;
      if (currentSession == null) {
        return;
      }
      final currentIndex = currentSession.pages.indexWhere(
        (currentPage) => currentPage.id == event.pageId,
      );
      if (currentIndex == -1 ||
          currentSession.pages[currentIndex].corners != requestedCorners ||
          currentSession.pages[currentIndex].rotation != requestedRotation) {
        return;
      }

      final failedPages = [...currentSession.pages];
      failedPages[currentIndex] = failedPages[currentIndex].copyWith(
        clearProcessedImagePath: true,
        processingStatus: DocumentProcessingStatus.failed,
      );
      emit(
        ScanSessionEditing(
          session: currentSession.copyWith(
            pages: List.unmodifiable(failedPages),
          ),
          selectedPageIndex: state.selectedPageIndex,
        ),
      );
    }
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
