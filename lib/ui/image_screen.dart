import 'dart:io';

import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  final String path;
  const ImageScreen({Key key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.file(File(path), fit: BoxFit.contain);
  }
}
