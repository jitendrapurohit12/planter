import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/helper/dialog_helper.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/helper/ui_helper.dart';
import 'package:gmt_planter/router/router.dart';
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
      isSettingsOpened = false,
      isTreeToggleOn = false;

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
    final camera = await Permission.camera.request();
    final microphone = await Permission.microphone.request();
    isCameraPerimssionGranted = camera.isGranted;
    isAudioPermissionGranted = microphone.isGranted;

    if (isCameraPerimssionGranted && isAudioPermissionGranted) {
      controller = CameraController(
        cameras[0],
        ResolutionPreset.ultraHigh,
        imageFormatGroup: ImageFormatGroup.bgra8888,
      );
      controller.initialize().then((_) async {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      await controller.lockCaptureOrientation(DeviceOrientation.portraitUp);
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
        if (isTreeToggleOn) const VerticalDivider(color: kColorPrimaryDark, thickness: 4),
        if (isTreeToggleOn) const Divider(color: kColorPrimaryDark, thickness: 4),
        Align(
          alignment: Alignment.bottomCenter,
          child: HStack(
            [
              const SizedBox(width: 36, height: 36),
              ShutterButtonUI(
                () async {
                  final file = await controller.takePicture();
                  if (file != null) {
                    final copiedFile = await File(file.path).copy('${file.path}_copied');
                    final rotation =
                        await launchScreenRotate(context: context, path: copiedFile.path);
                    await fixExifRotation(file.path, rotation);
                    Navigator.pop(context, file.path);
                  }
                },
              ),
              getSvgImage(
                path: kImageTree,
                color: isTreeToggleOn ? Colors.green : Colors.grey,
                height: 36,
                width: 36,
              ).centered().onTap(() {
                isTreeToggleOn = !isTreeToggleOn;
                setState(() {});
              })
            ],
            axisSize: MainAxisSize.max,
            alignment: MainAxisAlignment.spaceEvenly,
          ).h(90),
        ).pOnly(bottom: 24)
      ],
      fit: StackFit.expand,
    );
  }
}
