import 'dart:io';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ImagePickerUI extends StatelessWidget {
  final File file;
  final String subtitle;
  final bool infiniteHeight;
  final double elevation;
  final VoidCallback callback;

  const ImagePickerUI({
    @required this.file,
    this.subtitle,
    this.infiniteHeight = false,
    @required this.callback,
    this.elevation = 8.0,
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
    ).roundedSM.elevation(elevation).clip(Clip.antiAlias).make().onTap(callback);
  }
}
