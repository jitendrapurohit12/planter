import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gmt_planter/controllers/planter_stories_notifier.dart';
import 'package:gmt_planter/helper/platform_widgets.dart';
import 'package:gmt_planter/helper/ui_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/router/router.dart';
import 'package:gmt_planter/ui/common_widget/bullet_row.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class ScreenProjectStoryList extends StatelessWidget {
  static const id = 'project_story_list';
  const ScreenProjectStoryList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: 'Your Project Stories'.text.make()),
      body: Consumer<ProjectStroyListNotifier>(
        builder: (context, value, child) {
          switch (value.state) {
            case NotifierState.initial:
              value.fetchProjectStories(context);
              return getPlatformProgress();
            case NotifierState.loaded:
            case NotifierState.fetchingMore:
              return const _FundList();
            case NotifierState.noData:
              return getNoDataUI(context: context);
            case NotifierState.error:
              return getErrorUI(
                  context: context, callback: () => value.fetchProjectStories(context));
            default:
              return getPlatformProgress();
          }
        },
      ),
    );
  }
}

class _FundList extends HookWidget {
  const _FundList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ProjectStroyListNotifier>(context);
    final controller = useScrollController();

    controller.addListener(() {
      if (controller.position.atEdge) {
        if (controller.position.pixels != 0) {
          notifier.fetchMore(context);
        }
      }
    });

    return Consumer<ProjectStroyListNotifier>(
      builder: (context, value, child) {
        final list = value.items;
        return RefreshIndicator(
          onRefresh: () => notifier.resfresh(context),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: controller,
            itemCount: list.length + 1,
            itemBuilder: (context, index) {
              if (index == list.length) {
                if (value.allFetched) {
                  return 'All data fetched'.text.blue400.bold.xl.makeCentered().py12();
                } else {
                  return 'Fetching more...'.text.green400.bold.xl.makeCentered().py12();
                }
              }

              final model = list[index];

              return VxCard(
                VStack(
                  [
                    ZStack(
                      [
                        getCachedImage(path: model.thumbnailUrl).h24(context).wFull(context),
                        CircleAvatar(
                          child: IconButton(
                            onPressed: () => launchEditStory(model, context: context),
                            icon: const Icon(Icons.edit),
                          ).objectTopRight(),
                        ).p8()
                      ],
                      alignment: Alignment.topRight,
                    ),
                    VStack([
                      if (model.storyTitle != null)
                        BulletRow('Title', model.storyTitle, includePadding: false),
                      if (model.caption != null)
                        BulletRow('Caption', model.caption, includePadding: false),
                      if (model.storyDescription != null)
                        BulletRow('Description', model.storyDescription, includePadding: false),
                      for (int i = 0; i < model.project.length; i++)
                        BulletRow(
                          'Project ${i + 1}',
                          model.project[i].projectName ?? '',
                          includePadding: false,
                        ),
                    ]).py8().px16(),
                  ],
                ),
              ).rounded.elevation(8).make().px8().py4();
            },
          ),
        );
      },
    );
  }
}
