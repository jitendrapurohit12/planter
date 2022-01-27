import 'package:flutter/material.dart';
import 'package:gmt_planter/controllers/project_detail_controller.dart';
import 'package:gmt_planter/helper/platform_widgets.dart';
import 'package:gmt_planter/helper/ui_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/ui/screens/project_details/tab_ui.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class ScreenProjectDetails extends StatelessWidget {
  static const id = 'project_details';
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final projectName = args['project_name'] as String;
    final projectId = args['project_id'] as int;
    return Scaffold(
      appBar: customAppbar(title: projectName),
      body: Consumer<ProjectDetailController>(
        builder: (_, notifier, __) {
          switch (notifier.state) {
            case NotifierState.initial:
              notifier.getProjectDetails(context: context, id: projectId);
              return getPlatformProgress();
            case NotifierState.loaded:
              return VStack([
                VxBox(
                        child: VxCard(
                  getCachedImage(path: notifier.model.data.thumbnailUrl),
                ).clip(Clip.antiAlias).rounded.make())
                    .rounded
                    .width(double.maxFinite)
                    .height(context.percentHeight * 26)
                    .make()
                    .p12(),
                Expanded(child: TabUI()),
              ]);
              break;
            case NotifierState.noData:
              return noDataText(context: context);
              break;
            case NotifierState.error:
              return getErrorUI(
                context: context,
                callback: () => notifier.getProjectDetails(context: context, id: projectId),
              );
              break;
            default:
              return getPlatformProgress();
          }
        },
      ),
    );
  }
}
