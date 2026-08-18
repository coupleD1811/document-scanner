import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

enum CameraPermissionOutcome { granted, denied, permanentlyDenied, restricted }

enum CameraAccessFailure { noCamera }

class CameraAccessException implements Exception {
  const CameraAccessException(this.failure);

  final CameraAccessFailure failure;
}

abstract interface class CameraAccessService {
  CameraController? get controller;

  Future<CameraPermissionOutcome> requestPermission();

  Future<void> initializeCamera();

  Future<String> capture();

  Future<bool> openSettings();

  Future<void> disposeCamera();
}

class SystemCameraAccessService implements CameraAccessService {
  CameraController? _controller;

  @override
  CameraController? get controller => _controller;

  @override
  Future<CameraPermissionOutcome> requestPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
    }

    if (status.isGranted) {
      return CameraPermissionOutcome.granted;
    }
    if (status.isPermanentlyDenied) {
      return CameraPermissionOutcome.permanentlyDenied;
    }
    if (status.isRestricted) {
      return CameraPermissionOutcome.restricted;
    }
    return CameraPermissionOutcome.denied;
  }

  @override
  Future<void> initializeCamera() async {
    await disposeCamera();
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw const CameraAccessException(CameraAccessFailure.noCamera);
    }

    final camera = cameras.cast<CameraDescription?>().firstWhere(
      (camera) => camera?.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    )!;
    final controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await controller.initialize();
      _controller = controller;
    } on Object {
      await controller.dispose();
      rethrow;
    }
  }

  @override
  Future<String> capture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      throw StateError('Camera is not initialized.');
    }

    final image = await controller.takePicture();
    return image.path;
  }

  @override
  Future<bool> openSettings() => openAppSettings();

  @override
  Future<void> disposeCamera() async {
    final controller = _controller;
    _controller = null;
    await controller?.dispose();
  }
}
