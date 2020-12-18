import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocity_x/velocity_x.dart';

import 'platform_widgets.dart';

AppBar customAppbar({@required String title, List<Widget> actions}) {
  return AppBar(
    title: Text(title),
    actions: actions,
    centerTitle: true,
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
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: color,
    content: message.text.white.make(),
  ));
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

Widget errorText({@required BuildContext context}) {
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
