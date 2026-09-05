import 'dart:io';

import 'package:camera/camera.dart';
import 'package:document_scan/document_scan.dart' as document_scan;
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:scanly/features/scan/bloc/scan_camera_bloc.dart';
import 'package:scanly/features/scan/bloc/scan_session_bloc.dart';
import 'package:scanly/features/scan/model/document_corners.dart';
import 'package:scanly/features/scan/model/document_edge_detection_status.dart';
import 'package:scanly/features/scan/model/document_processing_status.dart';
import 'package:scanly/features/scan/model/normalized_document_image.dart';
import 'package:scanly/features/scan/model/normalized_point.dart';
import 'package:scanly/features/scan/model/processed_document_image.dart';
import 'package:scanly/features/scan/model/scan_filter.dart';
import 'package:scanly/features/scan/service/camera_access_service.dart';
import 'package:scanly/features/scan/service/document_edge_detector.dart';
import 'package:scanly/features/scan/service/document_image_normalizer.dart';
import 'package:scanly/features/scan/service/document_perspective_corrector.dart';

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
    final perspectiveCorrector = _FakeDocumentPerspectiveCorrector();
    final bloc = ScanSessionBloc(
      clock: () => start.add(Duration(microseconds: clockTick++)),
      perspectiveCorrector: perspectiveCorrector,
    );
    addTearDown(bloc.close);

    final firstPageState = await _dispatchAndWait(
      bloc,
      ScanSessionPageAdded(_normalizedImage(1)),
      matches: (state) =>
          state.session?.pages.length == 1 &&
          state.session?.pages.single.processingStatus ==
              DocumentProcessingStatus.completed,
    );
    expect(firstPageState, isA<ScanSessionEditing>());
    expect(firstPageState.session!.pages, hasLength(1));
    expect(firstPageState.session!.pages.single.pageIndex, 0);
    expect(firstPageState.selectedPageIndex, 0);
    expect(
      firstPageState.session!.pages.single.processedImagePath,
      '/tmp/page-1-normalized-processed-1.jpg',
    );

    final secondPageState = await _dispatchAndWait(
      bloc,
      ScanSessionPageAdded(_normalizedImage(2)),
      matches: (state) =>
          state.session?.pages.length == 2 &&
          state.session?.pages.last.processingStatus ==
              DocumentProcessingStatus.completed,
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
      matches: (state) =>
          state.session?.pages.last.corners == manualCorners &&
          state.session?.pages.last.processingStatus ==
              DocumentProcessingStatus.completed,
    );
    expect(adjustedState.session!.pages.last.corners, manualCorners);
    expect(
      adjustedState.session!.pages.last.processedImagePath,
      '/tmp/page-2-normalized-processed-3.jpg',
    );
    expect(perspectiveCorrector.receivedCorners.last, manualCorners);

    final pageId = adjustedState.session!.pages.last.id;
    final rotatedRightState = await _dispatchAndWait(
      bloc,
      ScanSessionPageRotationRequested(pageId: pageId, quarterTurns: 1),
      matches: (state) =>
          state.session?.pages.last.rotation == 90 &&
          state.session?.pages.last.processingStatus ==
              DocumentProcessingStatus.completed,
    );
    expect(rotatedRightState.session!.pages.last.displayPixelWidth, 1200);
    expect(rotatedRightState.session!.pages.last.displayPixelHeight, 900);
    expect(perspectiveCorrector.receivedRotations.last, 90);

    await _dispatchAndWait(
      bloc,
      ScanSessionPageRotationRequested(pageId: pageId, quarterTurns: -1),
      matches: (state) =>
          state.session?.pages.last.rotation == 0 &&
          state.session?.pages.last.processingStatus ==
              DocumentProcessingStatus.completed,
    );
    final rotatedLeftState = await _dispatchAndWait(
      bloc,
      ScanSessionPageRotationRequested(pageId: pageId, quarterTurns: -1),
      matches: (state) =>
          state.session?.pages.last.rotation == 270 &&
          state.session?.pages.last.processingStatus ==
              DocumentProcessingStatus.completed,
    );
    expect(rotatedLeftState.session!.pages.last.displayPixelWidth, 1200);
    expect(rotatedLeftState.session!.pages.last.displayPixelHeight, 900);
    expect(perspectiveCorrector.receivedRotations.last, 270);

    final filteredState = await _dispatchAndWait(
      bloc,
      ScanSessionPageFilterChanged(
        pageId: pageId,
        filter: ScanFilter.grayscale,
      ),
      matches: (state) =>
          state.session?.pages.last.filter == ScanFilter.grayscale &&
          state.session?.pages.last.processingStatus ==
              DocumentProcessingStatus.completed,
    );
    expect(filteredState.session!.pages.last.rotation, 270);
    expect(filteredState.session!.pages.last.corners, manualCorners);
    expect(perspectiveCorrector.receivedFilters.last, ScanFilter.grayscale);

    final imageAdjustedState = await _dispatchAndWait(
      bloc,
      ScanSessionPageAdjustmentsChanged(
        pageId: pageId,
        brightness: 25,
        contrast: -15,
      ),
      matches: (state) =>
          state.session?.pages.last.brightness == 25 &&
          state.session?.pages.last.contrast == -15 &&
          state.session?.pages.last.processingStatus ==
              DocumentProcessingStatus.completed,
    );
    expect(imageAdjustedState.session!.pages.last.rotation, 270);
    expect(imageAdjustedState.session!.pages.last.filter, ScanFilter.grayscale);
    expect(imageAdjustedState.session!.pages.last.corners, manualCorners);
    expect(perspectiveCorrector.receivedBrightness.last, 25);
    expect(perspectiveCorrector.receivedContrast.last, -15);

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

  test('cho phep thu lai khi crop va chinh phoi canh that bai', () async {
    final perspectiveCorrector = _FakeDocumentPerspectiveCorrector(
      remainingFailures: 1,
    );
    final bloc = ScanSessionBloc(perspectiveCorrector: perspectiveCorrector);
    addTearDown(bloc.close);

    final failedState = await _dispatchAndWait(
      bloc,
      ScanSessionPageAdded(_normalizedImage(1)),
      matches: (state) =>
          state.session?.pages.single.processingStatus ==
          DocumentProcessingStatus.failed,
    );
    final page = failedState.session!.pages.single;
    expect(page.processedImagePath, isNull);

    final completedState = await _dispatchAndWait(
      bloc,
      ScanSessionPageProcessingRequested(page.id),
      matches: (state) =>
          state.session?.pages.single.processingStatus ==
          DocumentProcessingStatus.completed,
    );

    expect(perspectiveCorrector.callCount, 2);
    expect(completedState.session!.pages.single.processedImagePath, isNotNull);
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

  test('crop perspective creates a separate upright image', () async {
    final directory = await Directory.systemTemp.createTemp(
      'scanly-perspective-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final sourcePath = '${directory.path}/normalized.jpg';
    final outputPath = '${directory.path}/processed.jpg';
    final sourceImage = img.Image(width: 200, height: 160);
    img.fill(sourceImage, color: img.ColorRgb8(245, 245, 245));
    img.fillRect(
      sourceImage,
      x1: 20,
      y1: 16,
      x2: 180,
      y2: 144,
      color: img.ColorRgb8(20, 110, 105),
    );
    await File(
      sourcePath,
    ).writeAsBytes(img.encodeJpg(sourceImage, quality: 95));
    final sourceBytes = await File(sourcePath).readAsBytes();
    final corrector = LocalDocumentPerspectiveCorrector(
      outputPathBuilder: (_) => outputPath,
    );
    const corners = DocumentCorners(
      topLeft: NormalizedPoint(x: 0.1, y: 0.1),
      topRight: NormalizedPoint(x: 0.9, y: 0.1),
      bottomRight: NormalizedPoint(x: 0.9, y: 0.9),
      bottomLeft: NormalizedPoint(x: 0.1, y: 0.9),
      source: DocumentCornersSource.manual,
    );

    final result = await corrector.correct(
      normalizedImagePath: sourcePath,
      corners: corners,
    );

    expect(result.imagePath, outputPath);
    expect(result.pixelWidth, closeTo(160, 1));
    expect(result.pixelHeight, closeTo(128, 1));
    expect(await File(outputPath).exists(), isTrue);
    expect(await File(sourcePath).readAsBytes(), sourceBytes);
    final processedImage = img.decodeJpg(await File(outputPath).readAsBytes());
    expect(processedImage, isNotNull);
    expect(processedImage!.width, result.pixelWidth);
    expect(processedImage.height, result.pixelHeight);

    final rotatedOutputPath = '${directory.path}/processed-rotated.jpg';
    final rotatedResult =
        await LocalDocumentPerspectiveCorrector(
          outputPathBuilder: (_) => rotatedOutputPath,
        ).correct(
          normalizedImagePath: sourcePath,
          corners: corners,
          rotationDegrees: 90,
        );

    expect(rotatedResult.pixelWidth, closeTo(128, 1));
    expect(rotatedResult.pixelHeight, closeTo(160, 1));
    expect(await File(rotatedOutputPath).exists(), isTrue);
    expect(await File(sourcePath).readAsBytes(), sourceBytes);
  });

  test('applies color, grayscale and black-white scan filters', () async {
    final directory = await Directory.systemTemp.createTemp('scanly-filter-');
    addTearDown(() => directory.delete(recursive: true));
    final sourcePath = '${directory.path}/filter-source.png';
    final sourceImage = img.Image(width: 120, height: 80);
    img.fill(sourceImage, color: img.ColorRgb8(245, 245, 245));
    img.fillRect(
      sourceImage,
      x1: 8,
      y1: 8,
      x2: 55,
      y2: 71,
      color: img.ColorRgb8(20, 80, 180),
    );
    img.fillRect(
      sourceImage,
      x1: 64,
      y1: 24,
      x2: 110,
      y2: 55,
      color: img.ColorRgb8(15, 15, 15),
    );
    await File(sourcePath).writeAsBytes(img.encodePng(sourceImage));

    var outputIndex = 0;
    Future<img.Image> process(
      ScanFilter filter, {
      int brightness = 0,
      int contrast = 0,
    }) async {
      final outputPath =
          '${directory.path}/${filter.name}-${outputIndex++}.jpg';
      await LocalDocumentPerspectiveCorrector(
        outputPathBuilder: (_) => outputPath,
      ).correct(
        normalizedImagePath: sourcePath,
        corners: DocumentCorners.fullImage,
        filter: filter,
        brightness: brightness,
        contrast: contrast,
      );
      return img.decodeJpg(await File(outputPath).readAsBytes())!;
    }

    final originalImage = await process(ScanFilter.original);
    final colorImage = await process(ScanFilter.color);
    final grayscaleImage = await process(ScanFilter.grayscale);
    final blackWhiteImage = await process(ScanFilter.blackAndWhite);
    final brighterImage = await process(ScanFilter.original, brightness: 50);
    final higherContrastImage = await process(
      ScanFilter.original,
      contrast: 50,
    );
    final colorPixel = colorImage.getPixel(30, 40);
    final grayPixel = grayscaleImage.getPixel(30, 40);
    final inkPixel = blackWhiteImage.getPixel(80, 40);
    final paperPixel = blackWhiteImage.getPixel(115, 10);

    expect((colorPixel.b - colorPixel.r).abs(), greaterThan(80));
    expect((grayPixel.r - grayPixel.g).abs(), lessThanOrEqualTo(3));
    expect((grayPixel.g - grayPixel.b).abs(), lessThanOrEqualTo(3));
    expect(inkPixel.r, lessThan(20));
    expect(paperPixel.r, greaterThan(235));
    expect(
      brighterImage.getPixel(30, 40).b,
      greaterThan(originalImage.getPixel(30, 40).b),
    );
    final originalRange =
        originalImage.getPixel(115, 10).r - originalImage.getPixel(80, 40).r;
    final adjustedRange =
        higherContrastImage.getPixel(115, 10).r -
        higherContrastImage.getPixel(80, 40).r;
    expect(adjustedRange, greaterThan(originalRange));
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
  ScanSessionEvent event, {
  bool Function(ScanSessionState state)? matches,
}) {
  final nextState = bloc.stream.firstWhere(matches ?? (_) => true);
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

class _FakeDocumentPerspectiveCorrector
    implements DocumentPerspectiveCorrector {
  _FakeDocumentPerspectiveCorrector({this.remainingFailures = 0});

  int remainingFailures;
  int callCount = 0;
  final receivedCorners = <DocumentCorners>[];
  final receivedRotations = <int>[];
  final receivedFilters = <ScanFilter>[];
  final receivedBrightness = <int>[];
  final receivedContrast = <int>[];

  @override
  Future<ProcessedDocumentImage> correct({
    required String normalizedImagePath,
    required DocumentCorners corners,
    int rotationDegrees = 0,
    ScanFilter filter = ScanFilter.original,
    int brightness = 0,
    int contrast = 0,
  }) async {
    callCount += 1;
    receivedCorners.add(corners);
    receivedRotations.add(rotationDegrees);
    receivedFilters.add(filter);
    receivedBrightness.add(brightness);
    receivedContrast.add(contrast);
    if (remainingFailures > 0) {
      remainingFailures -= 1;
      throw const PerspectiveCorrectionException(
        PerspectiveCorrectionFailure.processingFailed,
      );
    }

    final extensionIndex = normalizedImagePath.lastIndexOf('.');
    final basePath = extensionIndex == -1
        ? normalizedImagePath
        : normalizedImagePath.substring(0, extensionIndex);
    return ProcessedDocumentImage(
      imagePath: '$basePath-processed-$callCount.jpg',
      pixelWidth: rotationDegrees % 180 == 0 ? 900 : 1200,
      pixelHeight: rotationDegrees % 180 == 0 ? 1200 : 900,
    );
  }
}
