import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gmt_planter/controllers/login_controller.dart';
import 'package:gmt_planter/controllers/profile_controller.dart';
import 'package:gmt_planter/controllers/project_detail_controller.dart';
import 'package:gmt_planter/controllers/project_list_controller.dart';
import 'package:gmt_planter/controllers/receipt_controller.dart';
import 'package:gmt_planter/controllers/story_caption_controller.dart';
import 'package:gmt_planter/controllers/story_controller.dart';
import 'package:gmt_planter/models/project_list_model.dart';
import 'package:gmt_planter/prefs/shared_prefs.dart';
import 'package:gmt_planter/router/router.dart';
import 'package:gmt_planter/service/api_service.dart';
import 'package:provider/provider.dart';

Future<void> logout({@required BuildContext context}) async {
  await clearPrefs();
  launchLogin(context: context);
}

Future<Duration> zeroDelay() async {
  return Future.delayed(const Duration());
}

void performAfterDelay({VoidCallback callback}) {
  Future.delayed(const Duration(), callback);
}

Future<void> printToken() async {
  print(await getToken());
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

double getFileSize(File file) {
  final bytes = file.readAsBytesSync().lengthInBytes;
  return bytes / (1024 * 1024);
}

final providers = [
  Provider<ApiService>(create: (_) => ApiService()),
  ChangeNotifierProvider<LoginController>(create: (_) => LoginController()),
  ChangeNotifierProvider<StoryController>(create: (_) => StoryController()),
  ChangeNotifierProvider<ProfileController>(create: (_) => ProfileController()),
  ChangeNotifierProvider<ReceiptController>(create: (_) => ReceiptController()),
  ChangeNotifierProvider<ProjectListController>(
    create: (_) => ProjectListController(),
  ),
  ChangeNotifierProvider<ProjectDetailController>(
    create: (_) => ProjectDetailController(),
  ),
  ChangeNotifierProvider<StoryCaptionController>(
    create: (_) => StoryCaptionController(),
  ),
];
