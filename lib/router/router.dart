import 'package:flutter/material.dart';
import 'package:gmt_planter/controllers/project_detail_controller.dart';
import 'package:gmt_planter/ui/screens/dashboard/screen_dashboard.dart';
import 'package:gmt_planter/ui/screens/login/screen_login.dart';
import 'package:gmt_planter/ui/screens/profile/screen_profile.dart';
import 'package:gmt_planter/ui/screens/project_details/screen_project_details.dart';
import 'package:gmt_planter/ui/screens/receipt/screen_receipt.dart';
import 'package:provider/provider.dart';

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

Future<void> launchProfile({@required BuildContext context}) async {
  assert(context != null);

  Navigator.pushNamed(
    context,
    ScreenProfile.id,
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

  final notifier = Provider.of<ProjectDetailController>(context, listen: false);

  if (notifier?.model?.data?.id != projectId) {
    notifier.reset();
  }

  Navigator.pushNamed(
    context,
    ScreenProjectDetails.id,
    arguments: args,
  );
}

// Available Routes
final Map<String, Widget Function(BuildContext)> routes = {
  ScreenLogin.id: (_) => ScreenLogin(),
  ScreenProfile.id: (_) => ScreenProfile(),
  ScreenReciept.id: (_) => ScreenReciept(),
  ScreenDashboard.id: (_) => ScreenDashboard(),
  ScreenProjectDetails.id: (_) => ScreenProjectDetails(),
};
