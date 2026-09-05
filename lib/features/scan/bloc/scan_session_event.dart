part of 'scan_session_bloc.dart';

sealed class ScanSessionEvent extends Equatable {
  const ScanSessionEvent();

  @override
  List<Object?> get props => [];
}

final class ScanSessionCleared extends ScanSessionEvent {
  const ScanSessionCleared();
}

final class ScanSessionPageAdded extends ScanSessionEvent {
  const ScanSessionPageAdded(this.image);

  final NormalizedDocumentImage image;

  @override
  List<Object?> get props => [image];
}

final class ScanSessionPageSelected extends ScanSessionEvent {
  const ScanSessionPageSelected(this.pageIndex);

  final int pageIndex;

  @override
  List<Object?> get props => [pageIndex];
}

final class ScanSessionPageRemoved extends ScanSessionEvent {
  const ScanSessionPageRemoved(this.pageId);

  final String pageId;

  @override
  List<Object?> get props => [pageId];
}

final class ScanSessionPageCornersUpdated extends ScanSessionEvent {
  const ScanSessionPageCornersUpdated({
    required this.pageId,
    required this.corners,
  });

  final String pageId;
  final DocumentCorners corners;

  @override
  List<Object?> get props => [pageId, corners];
}

final class ScanSessionPageProcessingRequested extends ScanSessionEvent {
  const ScanSessionPageProcessingRequested(this.pageId);

  final String pageId;

  @override
  List<Object?> get props => [pageId];
}

final class ScanSessionPageRotationRequested extends ScanSessionEvent {
  const ScanSessionPageRotationRequested({
    required this.pageId,
    required this.quarterTurns,
  }) : assert(quarterTurns == -1 || quarterTurns == 1);

  final String pageId;
  final int quarterTurns;

  @override
  List<Object?> get props => [pageId, quarterTurns];
}

final class ScanSessionPageFilterChanged extends ScanSessionEvent {
  const ScanSessionPageFilterChanged({
    required this.pageId,
    required this.filter,
  });

  final String pageId;
  final ScanFilter filter;

  @override
  List<Object?> get props => [pageId, filter];
}

final class ScanSessionPageAdjustmentsChanged extends ScanSessionEvent {
  const ScanSessionPageAdjustmentsChanged({
    required this.pageId,
    required this.brightness,
    required this.contrast,
  }) : assert(brightness >= -100 && brightness <= 100),
       assert(contrast >= -100 && contrast <= 100);

  final String pageId;
  final int brightness;
  final int contrast;

  @override
  List<Object?> get props => [pageId, brightness, contrast];
}

final class ScanSessionPagesReordered extends ScanSessionEvent {
  const ScanSessionPagesReordered({
    required this.oldIndex,
    required this.newIndex,
  });

  final int oldIndex;
  final int newIndex;

  @override
  List<Object?> get props => [oldIndex, newIndex];
}
