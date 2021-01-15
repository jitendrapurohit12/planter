import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

class ImagePickerUI extends StatelessWidget {
  final File file;
  final String subtitle;
  final ImageSource source;
  final bool infiniteHeight;
  final Function(File) callback;

  const ImagePickerUI({
    @required this.file,
    this.subtitle,
    this.infiniteHeight = false,
    this.source = ImageSource.gallery,
    @required this.callback,
  });
  @override
  Widget build(BuildContext context) {
    final ph = context.percentHeight;

    final pickimagePH = VStack(
      [
        Icon(
          Icons.add_a_photo_outlined,
          size: ph * 10,
          color: Colors.black.withOpacity(0.5),
        ),
        if (subtitle != null) (ph * 2).heightBox,
        if (subtitle != null) subtitle.text.xl2.gray500.make(),
      ],
      alignment: MainAxisAlignment.center,
      crossAlignment: CrossAxisAlignment.center,
    ).centered();

    return VxCard(
      file == null
          ? VxBox(child: pickimagePH)
              .width(double.maxFinite)
              .height(infiniteHeight ? null : ph * 25)
              .make()
          : Image.file(
              file,
              height: infiniteHeight ? null : ph * 25,
              width: double.maxFinite,
              fit: BoxFit.cover,
            ),
    ).roundedSM.elevation(8.0).clip(Clip.antiAlias).make().onTap(
      () async {
        final image = await ImagePicker().getImage(source: source);
        if (image != null) callback(File(image.path));
      },
    );
  }
}
