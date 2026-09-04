import 'dart:io';

import 'package:camera/camera.dart';
import 'package:document_scan/document_scan.dart' as document_scan;
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:scanly/features/scan/bloc/scan_camera_bloc.dart';
import 'package:scanly/features/scan/bloc/scan_session_bloc.dart';
import 'package:scanly/features/scan/model/document_corners.dart';
import 'package:scanly/features/scan/model/document_edge_detection_status.dart';
import 'package:scanly/features/scan/model/normalized_document_image.dart';
import 'package:scanly/features/scan/model/normalized_point.dart';
import 'package:scanly/features/scan/service/camera_access_service.dart';
import 'package:scanly/features/scan/service/document_edge_detector.dart';
import 'package:scanly/features/scan/service/document_image_normalizer.dart';

void main() {
  test('chap nhan tu giac tai lieu loi va tu choi cac goc bi cat cheo', () {
    const validCorners = DocumentCorners(
      topLeft: NormalizedPoint(x: 0.1, y: 0.08),
      topRight: NormalizedPoint(x: 0.92, y: 0.12),
      bottomRight: NormalizedPoint(x: 0.86, y: 0.94),
      bottomLeft: NormalizedPoint(x: 0.14, y: 0.88),
      source: DocumentCornersSource.detected,
    );
    const crossedCorners = DocumentCorners(
      topLeft: NormalizedPoint(x: 0.1, y: 0.1),
      topRight: NormalizedPoint(x: 0.9, y: 0.9),
      bottomRight: NormalizedPoint(x: 0.9, y: 0.1),
      bottomLeft: NormalizedPoint(x: 0.1, y: 0.9),
      source: DocumentCornersSource.manual,
    );

    expect(validCorners.isConvex, isTrue);
    expect(validCorners.isUsable, isTrue);
    expect(validCorners.area, greaterThan(0.5));
    expect(crossedCorners.isConvex, isFalse);
    expect(crossedCorners.isUsable, isFalse);
  });

  test('them, sap xep, xoa va huy cac trang trong phien quet', () async {
    final start = DateTime.utc(2026, 9, 4);
    var clockTick = 0;
    final bloc = ScanSessionBloc(
      clock: () => start.add(Duration(microseconds: clockTick++)),
    );
    addTearDown(bloc.close);

    final firstPageState = await _dispatchAndWait(
      bloc,
      ScanSessionPageAdded(_normalizedImage(1)),
    );
    expect(firstPageState, isA<ScanSessionEditing>());
    expect(firstPageState.session!.pages, hasLength(1));
    expect(firstPageState.session!.pages.single.pageIndex, 0);
    expect(firstPageState.selectedPageIndex, 0);

    final secondPageState = await _dispatchAndWait(
      bloc,
      ScanSessionPageAdded(_normalizedImage(2)),
    );
    expect(secondPageState.session!.pages, hasLength(2));
    expect(secondPageState.selectedPageIndex, 1);
    expect(
      secondPageState.session!.pages.map((page) => page.originalImagePath),
      ['/tmp/page-1.jpg', '/tmp/page-2.jpg'],
    );
    expect(
      secondPageState.session!.pages.last.normalizedImagePath,
      '/tmp/page-2-normalized.jpg',
    );
    expect(secondPageState.session!.pages.last.pixelWidth, 1200);
    expect(secondPageState.session!.pages.last.pixelHeight, 1600);

    const manualCorners = DocumentCorners(
      topLeft: NormalizedPoint(x: 0.1, y: 0.1),
      topRight: NormalizedPoint(x: 0.9, y: 0.1),
      bottomRight: NormalizedPoint(x: 0.9, y: 0.9),
      bottomLeft: NormalizedPoint(x: 0.1, y: 0.9),
      source: DocumentCornersSource.manual,
    );
    final adjustedState = await _dispatchAndWait(
      bloc,
      ScanSessionPageCornersUpdated(
        pageId: secondPageState.session!.pages.last.id,
        corners: manualCorners,
      ),
    );
    expect(adjustedState.session!.pages.last.corners, manualCorners);

    final reorderedState = await _dispatchAndWait(
      bloc,
      const ScanSessionPagesReordered(oldIndex: 0, newIndex: 1),
    );
    expect(
      reorderedState.session!.pages.map((page) => page.originalImagePath),
      ['/tmp/page-2.jpg', '/tmp/page-1.jpg'],
    );
    expect(reorderedState.session!.pages.map((page) => page.pageIndex), [0, 1]);
    expect(reorderedState.selectedPageIndex, 1);

    final pageToRemove = reorderedState.session!.pages.last;
    final removedState = await _dispatchAndWait(
      bloc,
      ScanSessionPageRemoved(pageToRemove.id),
    );
    expect(removedState.session!.pages, hasLength(1));
    expect(
      removedState.session!.pages.single.originalImagePath,
      '/tmp/page-2.jpg',
    );
    expect(removedState.selectedPageIndex, 0);

    final clearedState = await _dispatchAndWait(
      bloc,
      const ScanSessionCleared(),
    );
    expect(clearedState, const ScanSessionInitial());
  });

  test('normalizes and detects edges before completing capture', () async {
    final cameraService = _FakeCameraAccessService();
    final imageNormalizer = _FakeDocumentImageNormalizer();
    final edgeDetector = _FakeDocumentEdgeDetector(result: _detectedCorners);
    final bloc = ScanCameraBloc(
      cameraAccessService: cameraService,
      imageNormalizer: imageNormalizer,
      edgeDetector: edgeDetector,
    );
    addTearDown(bloc.close);

    bloc.add(const ScanCameraStarted());
    await bloc.stream.firstWhere(
      (state) => state.status == ScanCameraStatus.ready,
    );
    bloc.add(const ScanCameraCaptureRequested());
    final state = await bloc.stream.firstWhere(
      (state) => state.status == ScanCameraStatus.captured,
    );

    expect(cameraService.captureCount, 1);
    expect(imageNormalizer.receivedPaths, ['/tmp/captured.jpg']);
    expect(edgeDetector.receivedPaths, ['/tmp/captured-normalized.jpg']);
    expect(state.capturedImage?.corners, _detectedCorners);
    expect(state.capturedImage?.detectedCorners, _detectedCorners);
    expect(
      state.capturedImage?.edgeDetectionStatus,
      DocumentEdgeDetectionStatus.detected,
    );
  });

  test('uses the full image when document edges are not found', () async {
    final bloc = ScanCameraBloc(
      cameraAccessService: _FakeCameraAccessService(),
      imageNormalizer: _FakeDocumentImageNormalizer(),
      edgeDetector: _FakeDocumentEdgeDetector(),
    );
    addTearDown(bloc.close);

    bloc.add(const ScanCameraStarted());
    await bloc.stream.firstWhere(
      (state) => state.status == ScanCameraStatus.ready,
    );
    bloc.add(const ScanCameraCaptureRequested());
    final state = await bloc.stream.firstWhere(
      (state) => state.status == ScanCameraStatus.captured,
    );

    expect(state.capturedImage?.corners, DocumentCorners.fullImage);
    expect(state.capturedImage?.detectedCorners, isNull);
    expect(
      state.capturedImage?.edgeDetectionStatus,
      DocumentEdgeDetectionStatus.notFound,
    );
  });

  test('keeps the scan editable when edge detection fails', () async {
    final bloc = ScanCameraBloc(
      cameraAccessService: _FakeCameraAccessService(),
      imageNormalizer: _FakeDocumentImageNormalizer(),
      edgeDetector: _FakeDocumentEdgeDetector(shouldThrow: true),
    );
    addTearDown(bloc.close);

    bloc.add(const ScanCameraStarted());
    await bloc.stream.firstWhere(
      (state) => state.status == ScanCameraStatus.ready,
    );
    bloc.add(const ScanCameraCaptureRequested());
    final state = await bloc.stream.firstWhere(
      (state) => state.status == ScanCameraStatus.captured,
    );

    expect(state.capturedImage?.corners, DocumentCorners.fullImage);
    expect(
      state.capturedImage?.edgeDetectionStatus,
      DocumentEdgeDetectionStatus.failed,
    );
  });

  test('maps native detector corners into the Scanly model', () {
    const packageCorners = document_scan.DocumentCorners(
      topLeft: (x: 0.08, y: 0.12),
      topRight: (x: 0.91, y: 0.1),
      bottomRight: (x: 0.88, y: 0.94),
      bottomLeft: (x: 0.11, y: 0.9),
      confidence: 0.86,
    );

    final result = mapDetectedDocumentCorners(packageCorners);

    expect(result.source, DocumentCornersSource.detected);
    expect(result.topLeft.x, 0.08);
    expect(result.bottomRight.y, 0.94);
    expect(result.confidence, 0.86);
    expect(result.isUsable, isTrue);
  });

  test('bakes EXIF orientation and preserves the source image', () async {
    final directory = await Directory.systemTemp.createTemp(
      'scanly-normalizer-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final sourcePath = '${directory.path}/source.jpg';
    final outputPath = '${directory.path}/normalized.jpg';
    final sourceImage = img.Image(width: 2, height: 3)
      ..setPixelRgb(0, 0, 255, 0, 0)
      ..setPixelRgb(1, 2, 0, 0, 255);
    sourceImage.exif.imageIfd.orientation = 6;
    await File(
      sourcePath,
    ).writeAsBytes(img.encodeJpg(sourceImage, quality: 100));
    final normalizer = LocalDocumentImageNormalizer(
      outputPathBuilder: (_) => outputPath,
    );

    final result = await normalizer.normalize(sourcePath);

    expect(result.originalImagePath, sourcePath);
    expect(result.normalizedImagePath, outputPath);
    expect(result.pixelWidth, 3);
    expect(result.pixelHeight, 2);
    expect(await File(sourcePath).exists(), isTrue);
    expect(await File(outputPath).exists(), isTrue);

    final outputImage = img.decodeJpg(await File(outputPath).readAsBytes());
    expect(outputImage, isNotNull);
    expect(outputImage!.width, 3);
    expect(outputImage.height, 2);
    expect(outputImage.exif.isEmpty, isTrue);
  });

  test('reports a missing source image', () async {
    final normalizer = LocalDocumentImageNormalizer();

    await expectLater(
      normalizer.normalize('/tmp/scanly-file-that-does-not-exist.jpg'),
      throwsA(
        isA<ImageNormalizationException>().having(
          (error) => error.failure,
          'failure',
          ImageNormalizationFailure.sourceNotFound,
        ),
      ),
    );
  });
}

NormalizedDocumentImage _normalizedImage(int pageNumber) {
  return NormalizedDocumentImage(
    originalImagePath: '/tmp/page-$pageNumber.jpg',
    normalizedImagePath: '/tmp/page-$pageNumber-normalized.jpg',
    pixelWidth: 1200,
    pixelHeight: 1600,
  );
}

Future<ScanSessionState> _dispatchAndWait(
  ScanSessionBloc bloc,
  ScanSessionEvent event,
) {
  final nextState = bloc.stream.first;
  bloc.add(event);
  return nextState;
}

const _detectedCorners = DocumentCorners(
  topLeft: NormalizedPoint(x: 0.1, y: 0.12),
  topRight: NormalizedPoint(x: 0.9, y: 0.1),
  bottomRight: NormalizedPoint(x: 0.88, y: 0.92),
  bottomLeft: NormalizedPoint(x: 0.12, y: 0.9),
  source: DocumentCornersSource.detected,
);

class _FakeCameraAccessService implements CameraAccessService {
  int captureCount = 0;

  @override
  CameraController? get controller => null;

  @override
  Future<String> capture() async {
    captureCount += 1;
    return '/tmp/captured.jpg';
  }

  @override
  Future<void> disposeCamera() async {}

  @override
  Future<void> initializeCamera() async {}

  @override
  Future<bool> openSettings() async => true;

  @override
  Future<CameraPermissionOutcome> requestPermission() async {
    return CameraPermissionOutcome.granted;
  }
}

class _FakeDocumentImageNormalizer implements DocumentImageNormalizer {
  final receivedPaths = <String>[];
  final result = const NormalizedDocumentImage(
    originalImagePath: '/tmp/captured.jpg',
    normalizedImagePath: '/tmp/captured-normalized.jpg',
    pixelWidth: 1200,
    pixelHeight: 1600,
  );

  @override
  Future<NormalizedDocumentImage> normalize(String imagePath) async {
    receivedPaths.add(imagePath);
    return result;
  }
}

class _FakeDocumentEdgeDetector implements DocumentEdgeDetector {
  _FakeDocumentEdgeDetector({this.result, this.shouldThrow = false});

  final DocumentCorners? result;
  final bool shouldThrow;
  final receivedPaths = <String>[];

  @override
  Future<DocumentCorners?> detect(String normalizedImagePath) async {
    receivedPaths.add(normalizedImagePath);
    if (shouldThrow) {
      throw const DocumentEdgeDetectionException(
        DocumentEdgeDetectionFailure.detectionFailed,
      );
    }
    return result;
  }
}
