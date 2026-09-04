import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../app/theme/scanly_icons.dart';
import '../../../l10n/l10n.dart';
import '../bloc/scan_camera_bloc.dart';
import '../service/camera_access_service.dart';

class ScanCameraPage extends StatelessWidget {
  const ScanCameraPage({this.cameraAccessService, super.key});

  final CameraAccessService? cameraAccessService;

  @override
  Widget build(BuildContext context) {
    final service = cameraAccessService ?? SystemCameraAccessService();

    return BlocProvider(
      create: (_) =>
          ScanCameraBloc(cameraAccessService: service)
            ..add(const ScanCameraStarted()),
      child: const _ScanCameraView(),
    );
  }
}

class _ScanCameraView extends StatefulWidget {
  const _ScanCameraView();

  @override
  State<_ScanCameraView> createState() => _ScanCameraViewState();
}

class _ScanCameraViewState extends State<_ScanCameraView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final bloc = context.read<ScanCameraBloc>();
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      bloc.add(const ScanCameraPaused());
      return;
    }

    if (state == AppLifecycleState.resumed &&
        bloc.state.status == ScanCameraStatus.initial) {
      bloc.add(const ScanCameraStarted());
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(t.scanPageTitle),
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(LucideIcons.x),
        ),
      ),
      body: BlocConsumer<ScanCameraBloc, ScanCameraState>(
        listenWhen: (previous, current) =>
            previous.capturedImagePath != current.capturedImagePath &&
            current.capturedImagePath != null,
        listener: (context, state) {
          Navigator.of(context).pop(state.capturedImagePath);
        },
        builder: (context, state) {
          return switch (state.status) {
            ScanCameraStatus.ready || ScanCameraStatus.capturing =>
              _CameraReadyView(isCapturing: state.status.isCapturing),
            ScanCameraStatus.permissionDenied => _ScanStatusView(
              title: t.cameraPermissionDeniedTitle,
              message: t.cameraPermissionDeniedMessage,
              primaryLabel: t.retryAction,
              onPrimaryPressed: () =>
                  context.read<ScanCameraBloc>().add(const ScanCameraStarted()),
            ),
            ScanCameraStatus.permissionPermanentlyDenied => _ScanStatusView(
              title: t.cameraPermissionPermanentlyDeniedTitle,
              message: t.cameraPermissionPermanentlyDeniedMessage,
              primaryLabel: t.openSettingsAction,
              onPrimaryPressed: () => context.read<ScanCameraBloc>().add(
                const ScanCameraOpenSettingsRequested(),
              ),
            ),
            ScanCameraStatus.restricted => _ScanStatusView(
              title: t.cameraRestrictedTitle,
              message: t.cameraRestrictedMessage,
            ),
            ScanCameraStatus.unavailable => _ScanStatusView(
              title: t.cameraUnavailableTitle,
              message: t.cameraUnavailableMessage,
            ),
            ScanCameraStatus.failure => _ScanStatusView(
              title: t.cameraFailureTitle,
              message: t.cameraFailureMessage,
              primaryLabel: t.retryAction,
              onPrimaryPressed: () =>
                  context.read<ScanCameraBloc>().add(const ScanCameraStarted()),
            ),
            ScanCameraStatus.initial ||
            ScanCameraStatus.requestingPermission ||
            ScanCameraStatus.initializing => _CameraLoadingView(
              message: state.status == ScanCameraStatus.initializing
                  ? t.cameraInitializing
                  : t.cameraPermissionRequesting,
            ),
            ScanCameraStatus.captured => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class _CameraReadyView extends StatelessWidget {
  const _CameraReadyView({required this.isCapturing});

  final bool isCapturing;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ScanCameraBloc>();
    final controller = bloc.cameraAccessService.controller;

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(
          color: Colors.black,
          child: controller != null && controller.value.isInitialized
              ? CameraPreview(controller)
              : const Center(
                  child: Icon(
                    ScanlyIcons.scanDocument,
                    color: Colors.white54,
                    size: 72,
                  ),
                ),
        ),
        const IgnorePointer(child: _DocumentFrame()),
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            minimum: const EdgeInsets.only(bottom: 24),
            child: Semantics(
              button: true,
              label: context.l10n.captureDocumentTooltip,
              child: Tooltip(
                message: context.l10n.captureDocumentTooltip,
                child: InkResponse(
                  key: const ValueKey('camera-capture-button'),
                  onTap: isCapturing
                      ? null
                      : () => bloc.add(const ScanCameraCaptureRequested()),
                  radius: 46,
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.white70, width: 5),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: isCapturing
                        ? const SizedBox.square(
                            dimension: 24,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          )
                        : const Icon(
                            ScanlyIcons.scanDocument,
                            color: Color(0xFF087F78),
                            size: 30,
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DocumentFrame extends StatelessWidget {
  const _DocumentFrame();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.82,
        heightFactor: 0.58,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white70, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

class _CameraLoadingView extends StatelessWidget {
  const _CameraLoadingView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          const SizedBox(height: 18),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _ScanStatusView extends StatelessWidget {
  const _ScanStatusView({
    required this.title,
    required this.message,
    this.primaryLabel,
    this.onPrimaryPressed,
  });

  final String title;
  final String message;
  final String? primaryLabel;
  final VoidCallback? onPrimaryPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                ScanlyIcons.scanDocument,
                color: Colors.white,
                size: 64,
              ),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
              ),
              if (primaryLabel != null && onPrimaryPressed != null) ...[
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: onPrimaryPressed,
                  child: Text(primaryLabel!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

extension on ScanCameraStatus {
  bool get isCapturing => this == ScanCameraStatus.capturing;
}
