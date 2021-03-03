import 'package:flutter/material.dart';
import 'package:gmt_planter/controllers/project_detail_controller.dart';
import 'package:gmt_planter/models/unconfirmed_funds_model.dart';
import 'package:gmt_planter/ui/screens/camera/screen_camera.dart';
import 'package:gmt_planter/ui/screens/dashboard/screen_dashboard.dart';
import 'package:gmt_planter/ui/screens/language/screen_language.dart';
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

Future<void> launchLanguage({@required BuildContext context}) async {
  assert(context != null);

  Navigator.pushNamed(
    context,
    ScreenLanguage.id,
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

Future<bool> launchReceipt({
  @required BuildContext context,
  @required Data data,
}) async {
  assert(data != null);
  assert(context != null);

  final args = {'data': data};

  final result = await Navigator.pushNamed(
    context,
    ScreenReciept.id,
    arguments: args,
  );

  return result as bool;
}

Future<String> launchCamera({@required BuildContext context}) async {
  assert(context != null);

  final result = await Navigator.pushNamed(
    context,
    ScreenCamera.id,
  );

  return result as String;
}

// Available Routes
final Map<String, Widget Function(BuildContext)> routes = {
  ScreenLogin.id: (_) => ScreenLogin(),
  ScreenCamera.id: (_) => ScreenCamera(),
  ScreenProfile.id: (_) => ScreenProfile(),
  ScreenReciept.id: (_) => ScreenReciept(),
  ScreenLanguage.id: (_) => ScreenLanguage(),
  ScreenDashboard.id: (_) => ScreenDashboard(),
  ScreenProjectDetails.id: (_) => ScreenProjectDetails(),
};
