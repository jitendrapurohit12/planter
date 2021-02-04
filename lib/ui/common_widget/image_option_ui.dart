import 'package:flutter/material.dart';
import 'package:gmt_planter/style/decorations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:gmt_planter/style/text_styles.dart';

class ImageOptionUI extends StatelessWidget {
  final Function(ImageSource) callback;

  const ImageOptionUI({@required this.callback});
  @override
  Widget build(BuildContext context) {
    final ph = context.percentHeight;
    return VStack([
      (ph * 2).heightBox,
      _getListTile(
        context: context,
        title: 'Camera',
        icon: Icons.camera_alt,
        iconColor: Colors.amber,
        callback: () {
          callback(ImageSource.camera);
          Navigator.pop(context);
        },
      ),
      ph.heightBox,
      _getListTile(
        context: context,
        title: 'Gallery',
        icon: Icons.photo,
        iconColor: Colors.blueAccent,
        callback: () {
          callback(ImageSource.gallery);
          Navigator.pop(context);
        },
      ),
      (ph * 4).heightBox,
    ]);
  }

  Widget _getListTile({
    @required BuildContext context,
    @required String title,
    @required IconData icon,
    Color iconColor,
    @required VoidCallback callback,
  }) {
    return ListTile(
      title: title.text.textStyle(receiptTitleStyle(context: context)).make(),
      onTap: callback,
      leading: Icon(icon, color: iconColor),
      shape: listTileShape(radius: 12),
    ).px16();
  }
}
