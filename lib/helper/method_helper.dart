import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/controllers/caption_controller.dart';
import 'package:gmt_planter/controllers/fund_history_notifier.dart';
import 'package:gmt_planter/controllers/language_controller.dart';
import 'package:gmt_planter/controllers/login_controller.dart';
import 'package:gmt_planter/controllers/notification_controller.dart';
import 'package:gmt_planter/controllers/planter_stories_notifier.dart';
import 'package:gmt_planter/controllers/profile_controller.dart';
import 'package:gmt_planter/controllers/project_detail_controller.dart';
import 'package:gmt_planter/controllers/project_list_controller.dart';
import 'package:gmt_planter/controllers/receipt_controller.dart';
import 'package:gmt_planter/controllers/story_controller.dart';
import 'package:gmt_planter/controllers/story_update_controller.dart';
import 'package:gmt_planter/controllers/unconfirmed_funds_controller.dart';
import 'package:gmt_planter/controllers/version_controller.dart';
import 'package:gmt_planter/helper/dialog_helper.dart';
import 'package:gmt_planter/models/project_list_model.dart';
import 'package:gmt_planter/models/translation_model.dart';
import 'package:gmt_planter/models/version_model.dart';
import 'package:gmt_planter/prefs/shared_prefs.dart';
import 'package:gmt_planter/router/router.dart';
import 'package:gmt_planter/service/api_service.dart';
import 'package:image/image.dart' as ui;
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../prefs/shared_prefs.dart';

Future<void> logout(BuildContext context) async {
  final confirm = await showActionDialog(
    context: context,
    title: 'Logout?',
    content: 'Confirm Logout?',
    button1: kButtonYes,
    button2: kButtonNo,
  );

  if (confirm == null || confirm == kButtonNo) return;

  await showProgressDialog(context);

  try {
    await ApiService().logout();
    initateLogout(context);
  } catch (e) {
    initateLogout(context);
  }
}

Future initateLogout(BuildContext context) async {
  await clearPrefs();
  Provider.of<LoginController>(context, listen: false).reset();
  Provider.of<ProfileController>(context, listen: false).reset();
  Provider.of<ProjectDetailController>(context, listen: false).reset();
  Provider.of<ProjectListController>(context, listen: false).reset();
  Provider.of<ReceiptController>(context, listen: false).reset();
  Provider.of<StoryController>(context, listen: false).reset();
  Provider.of<UnconfirmedFundsController>(context, listen: false).reset();
  Provider.of<FundHistoryNotifier>(context, listen: false).reset();
  Provider.of<LoginController>(context, listen: false).reset();
  Navigator.pop(context);
  launchLogin(context: context);
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

Map<String, int> getProjectNames(List<ProjectModel> list) {
  final value = <String, int>{};

  for (final project in list) {
    value[project.name] = project.id;
  }
  return value;
}

Map<String, int> getCaptions(CaptionModel model, String languageCode) {
  final value = <String, int>{};
  final languageCode = getLanguageCode();
  for (final caption in model.data) {
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

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load(path);

  final file = File('${(await getApplicationDocumentsDirectory()).path}/watermark.png');
  await file
      .writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  return file;
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
  Provider(create: (_) => NotificationNotifier()),
  ChangeNotifierProvider(create: (_) => LoginController()),
  ChangeNotifierProvider(create: (_) => StoryController()),
  ChangeNotifierProvider(create: (_) => LanguageNotifier()),
  ChangeNotifierProvider(create: (_) => VersionControler()),
  ChangeNotifierProvider(create: (_) => CaptionController()),
  ChangeNotifierProvider(create: (_) => ProfileController()),
  ChangeNotifierProvider(create: (_) => ReceiptController()),
  ChangeNotifierProvider(create: (_) => FundHistoryNotifier()),
  ChangeNotifierProvider(create: (_) => StoryUpdateController()),
  ChangeNotifierProvider(create: (_) => ProjectListController()),
  ChangeNotifierProvider(create: (_) => ProjectDetailController()),
  ChangeNotifierProvider(create: (_) => ProjectStroyListNotifier()),
  ChangeNotifierProvider(create: (_) => UnconfirmedFundsController()),
];

Color getStatusColor(String status) {
  switch (status) {
    case 'Accepted':
      return Colors.green;
    case 'Rejected':
      return Colors.red;
    case 'Pending_confirmation':
      return Colors.yellow;
    default:
      return Colors.blue;
  }
}

IconData getStatusIcon(String status) {
  switch (status) {
    case 'Accepted':
      return Icons.check;
    case 'Rejected':
      return Icons.clear;
    case 'Pending_confirmation':
      return Icons.schedule;
    default:
      return Icons.help;
  }
}
