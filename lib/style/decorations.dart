import 'package:flutter/material.dart';

BorderRadius getRadius({double radius = 8.0}) => BorderRadius.circular(radius);

BoxDecoration kImageOverlayDecoration({double radius = 8.0}) => BoxDecoration(
      borderRadius: getRadius(radius: radius),
      gradient: const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          Colors.black,
          Colors.transparent,
        ],
      ),
    );

BoxDecoration loginDecoration({
  double radius = 8.0,
  Color color = Colors.transparent,
}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
    ),
  );
}
