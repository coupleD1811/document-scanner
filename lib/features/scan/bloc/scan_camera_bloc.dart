import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/normalized_document_image.dart';
import '../model/document_corners.dart';
import '../model/document_edge_detection_status.dart';
import '../service/camera_access_service.dart';
import '../service/document_edge_detector.dart';
import '../service/document_image_normalizer.dart';

part 'scan_camera_event.dart';
part 'scan_camera_state.dart';

class ScanCameraBloc extends Bloc<ScanCameraEvent, ScanCameraState> {
  ScanCameraBloc({
    required CameraAccessService cameraAccessService,
    required DocumentImageNormalizer imageNormalizer,
    required DocumentEdgeDetector edgeDetector,
  }) : _imageNormalizer = imageNormalizer,
       _edgeDetector = edgeDetector,
       _cameraAccessService = cameraAccessService,
       super(const ScanCameraState()) {
    on<ScanCameraStarted>(_onStarted);
    on<ScanCameraCaptureRequested>(_onCaptureRequested);
    on<ScanCameraOpenSettingsRequested>(_onOpenSettingsRequested);
    on<ScanCameraPaused>(_onPaused);
  }

  final CameraAccessService _cameraAccessService;
  final DocumentImageNormalizer _imageNormalizer;
  final DocumentEdgeDetector _edgeDetector;

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
      emit(const ScanCameraState(status: ScanCameraStatus.normalizing));
      final normalizedImage = await _imageNormalizer.normalize(imagePath);
      emit(const ScanCameraState(status: ScanCameraStatus.detectingEdges));
      final preparedImage = await _detectEdges(normalizedImage);
      emit(
        ScanCameraState(
          status: ScanCameraStatus.captured,
          capturedImage: preparedImage,
        ),
      );
    } on ImageNormalizationException {
      emit(
        const ScanCameraState(status: ScanCameraStatus.normalizationFailure),
      );
    } on Object {
      emit(const ScanCameraState(status: ScanCameraStatus.failure));
    }
  }

  Future<NormalizedDocumentImage> _detectEdges(
    NormalizedDocumentImage image,
  ) async {
    try {
      final detectedCorners = await _edgeDetector.detect(
        image.normalizedImagePath,
      );
      if (detectedCorners == null || !detectedCorners.isUsable) {
        return image.copyWith(
          corners: DocumentCorners.fullImage,
          clearDetectedCorners: true,
          edgeDetectionStatus: DocumentEdgeDetectionStatus.notFound,
        );
      }

      return image.copyWith(
        corners: detectedCorners,
        detectedCorners: detectedCorners,
        edgeDetectionStatus: DocumentEdgeDetectionStatus.detected,
      );
    } on Object {
      return image.copyWith(
        corners: DocumentCorners.fullImage,
        clearDetectedCorners: true,
        edgeDetectionStatus: DocumentEdgeDetectionStatus.failed,
      );
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
