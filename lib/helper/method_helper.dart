import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gmt_planter/controllers/auth_controller.dart';
import 'package:gmt_planter/controllers/project_detail_controller.dart';
import 'package:gmt_planter/controllers/project_list_controller.dart';
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

final providers = [
  Provider<ApiService>(create: (_) => ApiService()),
  ChangeNotifierProvider<AuthController>(create: (_) => AuthController()),
  ChangeNotifierProvider<ProjectListController>(
    create: (_) => ProjectListController(),
  ),
  ChangeNotifierProvider<ProjectDetailController>(
    create: (_) => ProjectDetailController(),
  ),
];
