import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/style/decorations.dart';
import 'package:gmt_planter/ui/common_widget/custom_button.dart';
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
  BoxFit fit = BoxFit.cover,
}) {
  return SvgPicture.asset(
    path,
    width: width,
    height: height,
    color: color,
    fit: fit,
  );
}

Widget getImage({
  @required String path,
  BoxFit fit = BoxFit.cover,
}) {
  return Image.asset(path, fit: fit);
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

Widget getErrorUI(
    {@required BuildContext context, VoidCallback callback, String action = 'RETRY'}) {
  assert(context != null);
  return Center(
    child: VStack(
      [
        'SOMETHING WENT WRONG'.text.red500.xl3.center.semiBold.make(),
        if (callback != null) const SizedBox(height: 24),
        if (callback != null) CustomButton(title: action, callback: callback)
      ],
      crossAlignment: CrossAxisAlignment.center,
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
    (context) => ImageOptionUI(callback: callback),
    backgroundColor: kColorBottomsheetBackground,
    shape: listTileShape(radius: 12),
  );
}
