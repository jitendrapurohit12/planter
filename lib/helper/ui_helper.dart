import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/style/decorations.dart';
import 'package:gmt_planter/ui/common_widget/image_option_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

import 'platform_widgets.dart';

AppBar customAppbar({@required String title, List<Widget> actions}) {
  return AppBar(
    title: Text(title),
    actions: actions,
  );
}

BottomNavigationBarItem getBottomNavigationBarItem({
  @required Widget icon,
  @required String title,
  @required Widget activeIcon,
}) {
  assert(activeIcon != null);
  assert(title != null);
  assert(icon != null);
  return BottomNavigationBarItem(
    icon: icon,
    label: title,
    activeIcon: activeIcon,
  );
}

Widget getSvgImage({
  @required String path,
  double width = 24,
  double height = 24,
  Color color,
}) {
  return SvgPicture.asset(
    path,
    width: width,
    height: height,
    color: color,
  );
}

void showSnackbar({
  @required BuildContext context,
  @required String message,
  Color color = Colors.redAccent,
}) {
  performAfterDelay(
    callback: () => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: message.text.white.make(),
      ),
    ),
  );
}

Widget noDataText({@required BuildContext context}) {
  assert(context != null);
  return Center(
    child: Text(
      'NO DATA',
      style: Theme.of(context).textTheme.headline5,
    ),
  );
}

Widget getCachedImage({@required String path}) {
  return CachedNetworkImage(
    imageUrl: path,
    fit: BoxFit.cover,
    placeholder: (_, __) => getPlatformProgress(),
    errorWidget: (_, __, ___) => const Icon(
      Icons.error,
      color: Colors.red,
      size: 30,
    ),
  );
}

Widget getErrorUI({@required BuildContext context}) {
  assert(context != null);
  return Center(
    child: Text(
      'SOMETHING WENT WRONG',
      style: Theme.of(context).textTheme.headline5,
    ),
  );
}

Widget getNoDataUI({@required BuildContext context}) {
  return Center(
      child: Text(
    "It's empty here!",
    style: Theme.of(context).textTheme.headline5,
  ));
}

void showImageSourceBottomSheet({
  BuildContext context,
  Function(ImageSource) callback,
}) {
  Scaffold.of(context).showBottomSheet(
    (context) => ImageOptionUI(
      callback: callback,
    ),
    backgroundColor: kColorBottomsheetBackground,
    shape: listTileShape(radius: 12),
  );
}
