import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../service/camera_access_service.dart';

part 'scan_camera_event.dart';
part 'scan_camera_state.dart';

class ScanCameraBloc extends Bloc<ScanCameraEvent, ScanCameraState> {
  ScanCameraBloc({required CameraAccessService cameraAccessService})
    : _cameraAccessService = cameraAccessService,
      super(const ScanCameraState()) {
    on<ScanCameraStarted>(_onStarted);
    on<ScanCameraCaptureRequested>(_onCaptureRequested);
    on<ScanCameraOpenSettingsRequested>(_onOpenSettingsRequested);
    on<ScanCameraPaused>(_onPaused);
  }

  final CameraAccessService _cameraAccessService;

  CameraAccessService get cameraAccessService => _cameraAccessService;

  Future<void> _onStarted(
    ScanCameraStarted event,
    Emitter<ScanCameraState> emit,
  ) async {
    emit(const ScanCameraState(status: ScanCameraStatus.requestingPermission));

    try {
      final permission = await _cameraAccessService.requestPermission();
      switch (permission) {
        case CameraPermissionOutcome.denied:
          emit(
            const ScanCameraState(status: ScanCameraStatus.permissionDenied),
          );
          return;
        case CameraPermissionOutcome.permanentlyDenied:
          emit(
            const ScanCameraState(
              status: ScanCameraStatus.permissionPermanentlyDenied,
            ),
          );
          return;
        case CameraPermissionOutcome.restricted:
          emit(const ScanCameraState(status: ScanCameraStatus.restricted));
          return;
        case CameraPermissionOutcome.granted:
          break;
      }

      emit(const ScanCameraState(status: ScanCameraStatus.initializing));
      await _cameraAccessService.initializeCamera();
      emit(const ScanCameraState(status: ScanCameraStatus.ready));
    } on CameraAccessException catch (error) {
      if (error.failure == CameraAccessFailure.noCamera) {
        emit(const ScanCameraState(status: ScanCameraStatus.unavailable));
      }
    } on Object {
      emit(const ScanCameraState(status: ScanCameraStatus.failure));
    }
  }

  Future<void> _onCaptureRequested(
    ScanCameraCaptureRequested event,
    Emitter<ScanCameraState> emit,
  ) async {
    if (state.status != ScanCameraStatus.ready) {
      return;
    }

    emit(const ScanCameraState(status: ScanCameraStatus.capturing));
    try {
      final imagePath = await _cameraAccessService.capture();
      emit(
        ScanCameraState(
          status: ScanCameraStatus.captured,
          capturedImagePath: imagePath,
        ),
      );
    } on Object {
      emit(const ScanCameraState(status: ScanCameraStatus.failure));
    }
  }

  Future<void> _onOpenSettingsRequested(
    ScanCameraOpenSettingsRequested event,
    Emitter<ScanCameraState> emit,
  ) {
    return _cameraAccessService.openSettings();
  }

  Future<void> _onPaused(
    ScanCameraPaused event,
    Emitter<ScanCameraState> emit,
  ) async {
    await _cameraAccessService.disposeCamera();
    emit(const ScanCameraState());
  }

  @override
  Future<void> close() async {
    await _cameraAccessService.disposeCamera();
    return super.close();
  }
}
