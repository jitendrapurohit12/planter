import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/controllers/project_list_controller.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/helper/platform_widgets.dart';
import 'package:gmt_planter/helper/ui_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/models/project_list_model.dart';
import 'package:gmt_planter/router/router.dart';
import 'package:gmt_planter/service/api_service.dart';
import 'package:gmt_planter/style/text_styles.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class PageHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    printToken();
    return Consumer<ProjectListController>(
      // ignore: missing_return
      builder: (ctx, value, __) {
        switch (value.state) {
          case NotifierState.initial:
            value.getProjects(context);
            return getPlatformProgress();
          case NotifierState.fetching:
            return getPlatformProgress();
          case NotifierState.fetchingMore:
          case NotifierState.loaded:
            return ProjectList();
          case NotifierState.noData:
            return getNoDataUI(context: context);
          case NotifierState.error:
            final isUnauth =
                value.error.message != null && value.error.message == 'Unauthenticated.';
            showSnackbar(context: ctx, message: value.error.message);
            return getErrorUI(
              context: context,
              message: value.error.message,
              action: isUnauth ? kButtonLogout : null,
              callback: () => isUnauth ? logout(context) : value.getProjects(context),
            );
        }
      },
    );
  }
}

class ProjectList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ProjectListController>(context);
    final controller = useScrollController();

    controller.addListener(() {
      if (controller.position.atEdge) {
        if (controller.position.pixels != 0) {
          notifier.fetchMore(context);
        }
      }
    });
    return Consumer<ProjectListController>(
      builder: (context, value, child) {
        final list = value.list;
        return RefreshIndicator(
          child: ListView.builder(
            controller: controller,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
            itemCount: list.length + 1,
            itemBuilder: (context, index) {
              if (index == list.length) {
                if (value.allFetched) {
                  return 'All data fetched'.text.blue400.bold.xl.makeCentered().py12();
                } else {
                  return 'Fetching more...'.text.green400.bold.xl.makeCentered().py12();
                }
              }
              return ProjectUnit(project: list[index]);
            },
          ),
          onRefresh: () => notifier.refresh(context),
        );
      },
    );
  }
}

class ProjectUnit extends StatelessWidget {
  final ProjectModel project;

  const ProjectUnit({@required this.project});
  @override
  Widget build(BuildContext context) {
    print(project.thumbnailUrl);
    return SizedBox(
      height: context.percentHeight * 27,
      width: double.infinity,
      child: VxCard(
        ZStack(
          [
            getCachedImage(path: project.thumbnailUrl),
            VxBox()
                .withGradient(
                  LinearGradient(
                    colors: [Colors.black.withOpacity(0.8), Colors.black.withOpacity(0)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                )
                .make(),
            VxBox(
              child: project.name.text
                  .textStyle(whiteTitleStyle(context: context))
                  .make()
                  .pOnly(left: context.percentWidth * 4, bottom: context.percentWidth * 4),
            ).alignBottomLeft.make(),
          ],
          fit: StackFit.expand,
        ),
      ).elevation(8).clip(Clip.antiAlias).rounded.make().p8().onTap(
            () => launchProjectDetails(
              context: context,
              model: project,
            ),
          ),
    );
  }
}
