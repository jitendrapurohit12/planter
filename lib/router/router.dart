import 'package:flutter/material.dart';
import 'package:gmt_planter/ui/screens/dashboard/screen_dashboard.dart';
import 'package:gmt_planter/ui/screens/login/screen_login.dart';
import 'package:gmt_planter/ui/screens/project_details/screen_project_details.dart';

Future<void> launchLogin({@required BuildContext context}) async {
  assert(context != null);

  Navigator.pushNamedAndRemoveUntil(
    context,
    ScreenLogin.id,
    (_) => false,
  );
}

Future<void> launchDashboard({@required BuildContext context}) async {
  assert(context != null);

  Navigator.pushNamedAndRemoveUntil(
    context,
    ScreenDashboard.id,
    (_) => false,
  );
}

Future<void> launchProjectDetails({
  @required BuildContext context,
  @required String projectName,
  @required int projectId,
}) async {
  assert(projectId != null);
  assert(projectName != null);
  assert(context != null);

  final args = {
    'project_name': projectName,
    'project_id': projectId,
  };

  Navigator.pushNamed(
    context,
    ScreenProjectDetails.id,
    arguments: args,
  );
}

// Available Routes

final Map<String, Widget Function(BuildContext)> routes = {
  ScreenLogin.id: (_) => ScreenLogin(),
  ScreenDashboard.id: (_) => ScreenDashboard(),
  ScreenProjectDetails.id: (_) => ScreenProjectDetails(),
};
