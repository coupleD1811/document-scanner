part of 'scan_camera_bloc.dart';

enum ScanCameraStatus {
  initial,
  requestingPermission,
  initializing,
  ready,
  capturing,
  normalizing,
  detectingEdges,
  captured,
  permissionDenied,
  permissionPermanentlyDenied,
  restricted,
  unavailable,
  normalizationFailure,
  failure,
}

class ScanCameraState extends Equatable {
  const ScanCameraState({
    this.status = ScanCameraStatus.initial,
    this.capturedImage,
  });

  final ScanCameraStatus status;
  final NormalizedDocumentImage? capturedImage;

  @override
  List<Object?> get props => [status, capturedImage];
}
