import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/helper/dialog_helper.dart';
import 'package:gmt_planter/ui/common_widget/action_error.dart';
import 'package:gmt_planter/ui/screens/camera/shutter_button_ui.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../main.dart';

class ScreenCamera extends StatefulWidget {
  static const id = 'camera';

  @override
  _ScreenCameraState createState() => _ScreenCameraState();
}

class _ScreenCameraState extends State<ScreenCamera> with WidgetsBindingObserver {
  CameraController controller;
  bool isCameraPerimssionGranted = false,
      isAudioPermissionGranted = false,
      isSettingsOpened = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getStarted();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && isSettingsOpened) {
      isSettingsOpened = false;
      getStarted();
    }
  }

  Future<void> getStarted() async {
    isCameraPerimssionGranted = await Permission.camera.request().isGranted;
    isAudioPermissionGranted = await Permission.microphone.request().isGranted;

    if (isCameraPerimssionGranted && isAudioPermissionGranted) {
      controller = CameraController(cameras[0], ResolutionPreset.ultraHigh);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      final result = await showActionDialog(
        context: context,
        title:
            !isAudioPermissionGranted ? kTitleAudioPermissionDenied : kTitleCameraPermissionDenied,
        content: !isAudioPermissionGranted
            ? kDescriptionMicrohonePermissionDenied
            : kDescriptionCameraPermissionDenied,
        button1: kButtonDeny,
        button2: kButtonOpenSettings,
      );
      if (result == kButtonOpenSettings) {
        openAppSettings();
        isSettingsOpened = true;
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isCameraPerimssionGranted || !isAudioPermissionGranted) {
      return Scaffold(
        body: ActionError(
          error: kErrorCameraScreen,
          actionTitle: kButtonGrantPermission,
          callback: () {
            openAppSettings();
            isSettingsOpened = true;
          },
        ).centered(),
      );
    }
    if (!controller.value.isInitialized) {
      return Container();
    }
    return ZStack(
      [
        AspectRatio(aspectRatio: controller.value.aspectRatio, child: CameraPreview(controller)),
        const VerticalDivider(color: kColorPrimaryDark, thickness: 4),
        const Divider(color: kColorPrimaryDark, thickness: 4),
        Align(
          alignment: Alignment.bottomCenter,
          child: ShutterButtonUI(() async {
            final file = await controller.takePicture();
            if (file != null) {
              Navigator.pop(context, file.path);
            }
          }),
        ).pOnly(bottom: 24),
      ],
      fit: StackFit.expand,
    );
  }
}
