import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

Widget getPlatformProgress() => Center(
      child: PlatformWidget(
        material: (_, __) => const CircularProgressIndicator(),
        cupertino: (_, __) => const CupertinoActivityIndicator(),
      ),
    );
