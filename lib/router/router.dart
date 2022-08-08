import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gmt_planter/controllers/fund_history_notifier.dart';
import 'package:gmt_planter/controllers/profile_controller.dart';
import 'package:gmt_planter/controllers/project_detail_controller.dart';
import 'package:gmt_planter/controllers/receipt_controller.dart';
import 'package:gmt_planter/controllers/story_update_controller.dart';
import 'package:gmt_planter/models/project_list_model.dart';
import 'package:gmt_planter/models/project_story_list_model.dart';
import 'package:gmt_planter/models/story_model.dart';
import 'package:gmt_planter/models/unconfirmed_funds_model.dart' as uc_data;
import 'package:gmt_planter/ui/screens/camera/screen_camera.dart';
import 'package:gmt_planter/ui/screens/dashboard/screen_dashboard.dart';
import 'package:gmt_planter/ui/screens/edit_story/screen_edit_story.dart';
import 'package:gmt_planter/ui/screens/fund_history/screen_fund_history.dart';
import 'package:gmt_planter/ui/screens/language/screen_language.dart';
import 'package:gmt_planter/ui/screens/login/screen_login.dart';
import 'package:gmt_planter/ui/screens/profile/screen_profile.dart';
import 'package:gmt_planter/ui/screens/project_details/screen_project_details.dart';
import 'package:gmt_planter/ui/screens/project_story_list/screen_project_story_list.dart';
import 'package:gmt_planter/ui/screens/receipt/screen_receipt.dart';
import 'package:gmt_planter/ui/screens/rotation_fix/screen_rotation_fix.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

Future<void> launchLogin({@required BuildContext context}) async {
  assert(context != null);

  return Navigator.pushNamedAndRemoveUntil(
    context,
    ScreenLogin.id,
    (_) => false,
  );
}

Future<void> launchDashboard({@required BuildContext context}) async {
  assert(context != null);

  return Navigator.pushNamedAndRemoveUntil(
    context,
    ScreenDashboard.id,
    (_) => false,
  );
}

// Future<int> launchScreenRotate({@required BuildContext context, @required String path}) async {
//   assert(context != null);

//   final args = {'path': path};
//   File croppedFile = ;

//   return 1;
// }

Future<void> launchProfile({@required BuildContext context}) async {
  assert(context != null);
  await Provider.of<ProfileController>(context, listen: false).reset();

  return Navigator.pushNamed(
    context,
    ScreenProfile.id,
  );
}

Future<void> launchProjectStoryList({@required BuildContext context}) async {
  assert(context != null);

  return Navigator.pushNamed(
    context,
    ScreenProjectStoryList.id,
  );
}

Future<void> launchLanguage({@required BuildContext context}) async {
  assert(context != null);

  return Navigator.pushNamed(
    context,
    ScreenLanguage.id,
  );
}

Future<void> launchProjectDetails({
  @required BuildContext context,
  @required ProjectModel model,
}) async {
  assert(model != null);
  assert(context != null);

  final args = {
    'project_name': model.name,
    'project_id': model.id,
  };

  final notifier = Provider.of<ProjectDetailController>(context, listen: false);

  if (notifier?.model?.data?.id != model.id) {
    notifier.reset();
    notifier.boughtQty = model.boughtImpactQty;
    notifier.totalQty = model.projectImpactQty;
    notifier.completion = model.projectCompletion;
  }

  return Navigator.pushNamed(
    context,
    ScreenProjectDetails.id,
    arguments: args,
  );
}

Future<bool> launchReceipt({
  @required BuildContext context,
  @required uc_data.Data data,
  @required String status,
}) async {
  assert(data != null);
  assert(context != null);
  assert(status != null);

  final args = {'data': data, 'status': status};

  final result = await Navigator.pushNamed(
    context,
    ScreenReciept.id,
    arguments: args,
  );

  Provider.of<ReceiptController>(context, listen: false).reset();

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

Future launchFundHistory({@required BuildContext context}) async {
  assert(context != null);
  await Provider.of<FundHistoryNotifier>(context, listen: false).reset();

  await Navigator.pushNamed(context, ScreenFundHistory.id);
}

Future launchEditStory(Story model, {@required BuildContext context}) async {
  assert(context != null);
  await Provider.of<StoryUpdateController>(context, listen: false).reset();
  Provider.of<StoryUpdateController>(context, listen: false).model.caption = model.captionId;
  Provider.of<StoryUpdateController>(context, listen: false).model.sId = model.storyId;
  await Navigator.pushNamed(context, ScreenEditStory.id, arguments: {'model': model});
}

// Available Routes
final Map<String, Widget Function(BuildContext)> routes = {
  ScreenLogin.id: (_) => ScreenLogin(),
  ScreenCamera.id: (_) => ScreenCamera(),
  ScreenProfile.id: (_) => ScreenProfile(),
  ScreenReciept.id: (_) => ScreenReciept(),
  ScreenLanguage.id: (_) => ScreenLanguage(),
  ScreenEditStory.id: (_) => ScreenEditStory(),
  ScreenDashboard.id: (_) => ScreenDashboard(),
  ScreenFundHistory.id: (_) => const ScreenFundHistory(),
  ScreenRotationFix.id: (_) => const ScreenRotationFix(),
  ScreenProjectDetails.id: (_) => ScreenProjectDetails(),
  ScreenProjectStoryList.id: (_) => const ScreenProjectStoryList(),
};
