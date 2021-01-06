import 'package:flutter/material.dart';
import 'package:gmt_planter/controllers/project_list_controller.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/helper/platform_widgets.dart';
import 'package:gmt_planter/helper/ui_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/models/project_list_model.dart';
import 'package:gmt_planter/router/router.dart';
import 'package:gmt_planter/style/text_styles.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class PageHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    printToken();
    return Consumer<ProjectListController>(
      // ignore: missing_return
      builder: (_, value, __) {
        switch (value.state) {
          case NotifierState.initial:
            value.getProjects(context: context);
            return getPlatformProgress();
          case NotifierState.fetching:
            return getPlatformProgress();
          case NotifierState.loaded:
            return ProjectList();
          case NotifierState.noData:
            return getNoDataUI(context: context);
          case NotifierState.error:
            performAfterDelay(
              callback: () => context.showToast(msg: value.error.message),
            );
            return getErrorUI(context: context);
        }
      },
    );
  }
}

class ProjectList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final projectListController = Provider.of<ProjectListController>(context);
    final activeFundings =
        projectListController.model.data.activeFundingProjects;
    final activeManagement =
        projectListController.model.data.activeManagementProjects;
    final notDeployed = projectListController.model.data.notDeployedProjects;
    return SingleChildScrollView(
      child: Column(
        children: [
          if (activeFundings.isNotEmpty)
            ProjectUnit(
              title: 'Active Funding',
              projects: activeFundings,
            )
          else
            Container(),
          if (activeManagement.isNotEmpty)
            ProjectUnit(
              title: 'Active Management',
              projects: activeManagement,
            )
          else
            Container(),
          if (notDeployed.isNotEmpty)
            ProjectUnit(
              title: 'Not Deployed',
              projects: notDeployed,
            )
          else
            Container(),
        ],
      ),
    );
  }
}

class ProjectUnit extends StatelessWidget {
  final String title;
  final List<ProjectModel> projects;

  const ProjectUnit({@required this.title, @required this.projects});
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        HeightBox(context.percentHeight * 5),
        title.text
            .textStyle(primaryHeadTextStyle(context: context))
            .make()
            .pOnly(
                left: context.percentWidth * 4, bottom: context.percentHeight),
        for (final project in projects)
          SizedBox(
            height: context.percentHeight * 22,
            width: double.infinity,
            child: VxCard(
              ZStack(
                [
                  getCachedImage(path: project.thumbnailUrl),
                  VxBox()
                      .withGradient(
                        LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.black.withOpacity(0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      )
                      .make(),
                  VxBox(
                    child: project.name.text
                        .textStyle(buttonStyle(context: context))
                        .make()
                        .pOnly(
                            left: context.percentWidth * 4,
                            bottom: context.percentWidth * 4),
                  ).alignBottomLeft.make(),
                ],
                fit: StackFit.expand,
              ),
            ).elevation(8).clip(Clip.antiAlias).rounded.make().p8().onTap(
                  () => launchProjectDetails(
                    context: context,
                    projectId: project.id,
                    projectName: project.name,
                  ),
                ),
          )
      ],
    ).p8();
  }
}
