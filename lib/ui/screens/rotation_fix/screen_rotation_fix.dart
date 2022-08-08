import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:velocity_x/velocity_x.dart';

class ScreenRotationFix extends StatefulWidget {
  static const id = 'rotation_fix';

  const ScreenRotationFix({Key key}) : super(key: key);

  @override
  State<ScreenRotationFix> createState() => _ScreenRotationFixState();
}

class _ScreenRotationFixState extends State<ScreenRotationFix> {
  final GlobalKey editorKey = GlobalKey();
  bool _cropping = false;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as Map<String, String>;
    final path = args['path'];

    return Scaffold(
      body: Container(),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.crop),
          onPressed: () {
            cropImage();
          }),
    );
  }

  Future<void> cropImage() async {
    if (_cropping) {
      return;
    }

    editorKey.currentState;
    // final Uint8List fileData = Uint8List.fromList(await cropImageDataWithNativeLibrary(
    //         state: editorKey.currentState) as List<int>);
    // final String fileFath =
    //     await ImageSaver.save('extended_image_cropped_image.jpg', fileData);

    // showToast('save image : $fileFath');
    // _cropping = false;
  }
}
