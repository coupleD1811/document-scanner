part of 'scan_camera_bloc.dart';

sealed class ScanCameraEvent extends Equatable {
  const ScanCameraEvent();

  @override
  List<Object?> get props => [];
}

final class ScanCameraStarted extends ScanCameraEvent {
  const ScanCameraStarted();
}

final class ScanCameraCaptureRequested extends ScanCameraEvent {
  const ScanCameraCaptureRequested();
}

final class ScanCameraOpenSettingsRequested extends ScanCameraEvent {
  const ScanCameraOpenSettingsRequested();
}

final class ScanCameraPaused extends ScanCameraEvent {
  const ScanCameraPaused();
}
