import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/controllers/language_controller.dart';
import 'package:gmt_planter/controllers/login_controller.dart';
import 'package:gmt_planter/controllers/profile_controller.dart';
import 'package:gmt_planter/controllers/project_detail_controller.dart';
import 'package:gmt_planter/controllers/project_list_controller.dart';
import 'package:gmt_planter/controllers/receipt_controller.dart';
import 'package:gmt_planter/controllers/story_controller.dart';
import 'package:gmt_planter/controllers/unconfirmed_funds_controller.dart';
import 'package:gmt_planter/controllers/version_controller.dart';
import 'package:gmt_planter/helper/dialog_helper.dart';
import 'package:gmt_planter/models/failure.dart';
import 'package:gmt_planter/models/project_list_model.dart';
import 'package:gmt_planter/models/translation_model.dart';
import 'package:gmt_planter/models/version_model.dart';
import 'package:gmt_planter/prefs/shared_prefs.dart';
import 'package:gmt_planter/router/router.dart';
import 'package:gmt_planter/service/api_service.dart';
import 'package:provider/provider.dart';
import 'package:package_info/package_info.dart';
import 'package:image/image.dart' as img;
import 'package:url_launcher/url_launcher.dart';

import '../prefs/shared_prefs.dart';

Future<void> logout(BuildContext context, Function(Failure) error) async {
  final confirm = await showActionDialog(
    context: context,
    title: 'Logout?',
    content: 'Confirm Logout?',
    button1: kButtonYes,
    button2: kButtonNo,
  );

  if (confirm == null || confirm == kButtonNo) return;

  await showProgressDialog(context);

  final result = await ApiService().logout().catchError((e) {
    Navigator.pop(context);
    error(e as Failure);
  });
  if (result) {
    await clearPrefs();
    Provider.of<LoginController>(context, listen: false).reset();
    Provider.of<ProfileController>(context, listen: false).reset();
    Provider.of<ProjectDetailController>(context, listen: false).reset();
    Provider.of<ProjectListController>(context, listen: false).reset();
    Provider.of<ReceiptController>(context, listen: false).reset();
    Provider.of<StoryController>(context, listen: false).reset();
    Provider.of<UnconfirmedFundsController>(context, listen: false).reset();
    Provider.of<LoginController>(context, listen: false).reset();
    Navigator.pop(context);
    launchLogin(context: context);
  }
}

Future<Duration> zeroDelay() async {
  return Future.delayed(const Duration());
}

void performAfterDelay({VoidCallback callback}) {
  Future.delayed(const Duration(), callback);
}

Future<void> printToken() async {
  //print(await getToken());
}

Map<String, int> getProjectNames(ProjectListModel model) {
  final value = <String, int>{};

  for (final project in model.data.activeFundingProjects) {
    value[project.name] = project.id;
  }

  for (final project in model.data.activeManagementProjects) {
    value[project.name] = project.id;
  }

  for (final project in model.data.notDeployedProjects) {
    value[project.name] = project.id;
  }

  return value;
}

Map<String, int> getCaptions(TranslationModel model) {
  final value = <String, int>{};
  for (final caption in model.captions) {
    value[caption.name] = caption.id;
  }

  return value;
}

String getValueFromMap(int value, Map<String, int> map) {
  String result;
  map.forEach((k, v) {
    if (v == value) result = k;
  });

  return result;
}

double getFileSize(File file) {
  final bytes = file.readAsBytesSync().lengthInBytes;
  return bytes / 1000000;
}

Future<void> rotateimage(String path) async {
  final img.Image capturedImage = img.decodeImage(await File(path).readAsBytes());
  final img.Image orientedImage = img.bakeOrientation(capturedImage);
  await File(path).writeAsBytes(img.encodeJpg(orientedImage));
}

Future<void> increasePostStoryCounter() async {
  final currentCount = await getStoryCounter();
  await saveStoryCounter(value: currentCount + 1);
}

bool isZero(String str) {
  final d = double.parse(str);
  return d == 0.0;
}

String getPaymentButtonTitle(String status) {
  switch (status) {
    case kStatusRejected:
      return 'Reject Fund';
    default:
      return 'Accept Fund';
  }
}

Future<bool> letUserIn(VersionModel model) async {
  final packageInfo = await PackageInfo.fromPlatform();

  final buildNumber = int.parse(packageInfo.buildNumber);

  bool result = true;
  for (final data in model.data) {
    if (data.version > buildNumber && data.isMandatory == 'yes' && result) {
      result = false;
    }
  }

  return result;
}

Future gotoStores() async {
  final packageInfo = await PackageInfo.fromPlatform();

  final packageName = packageInfo.packageName;

  launch('https://play.google.com/store/apps/details?id=$packageName');
}

final providers = [
  Provider(create: (_) => ApiService()),
  ChangeNotifierProvider(create: (_) => LoginController()),
  ChangeNotifierProvider(create: (_) => StoryController()),
  ChangeNotifierProvider(create: (_) => VersionControler()),
  ChangeNotifierProvider(create: (_) => LanguageNotifier()),
  ChangeNotifierProvider(create: (_) => ProfileController()),
  ChangeNotifierProvider(create: (_) => ReceiptController()),
  ChangeNotifierProvider(create: (_) => ProjectListController()),
  ChangeNotifierProvider(create: (_) => ProjectDetailController()),
  ChangeNotifierProvider(create: (_) => UnconfirmedFundsController()),
];
