part of 'scan_camera_bloc.dart';

enum ScanCameraStatus {
  initial,
  requestingPermission,
  initializing,
  ready,
  capturing,
  captured,
  permissionDenied,
  permissionPermanentlyDenied,
  restricted,
  unavailable,
  failure,
}

class ScanCameraState extends Equatable {
  const ScanCameraState({
    this.status = ScanCameraStatus.initial,
    this.capturedImagePath,
  });

  final ScanCameraStatus status;
  final String? capturedImagePath;

  @override
  List<Object?> get props => [status, capturedImagePath];
}
