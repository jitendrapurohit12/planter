import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/ui/common_widget/custom_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:gmt_planter/controllers/project_list_controller.dart';
import 'package:gmt_planter/controllers/story_caption_controller.dart';
import 'package:gmt_planter/controllers/story_controller.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/helper/platform_widgets.dart';
import 'package:gmt_planter/helper/ui_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/ui/common_widget/custom_dropdown_button.dart';

class PageStory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<StoryCaptionController>(
      // ignore: missing_return
      builder: (_, captionController, __) {
        switch (captionController.state) {
          case NotifierState.initial:
            captionController.getStoryCaptions(context: context);
            return getPlatformProgress();
          case NotifierState.fetching:
            return getPlatformProgress();
          case NotifierState.loaded:
            return PageStoryContent();

          case NotifierState.noData:
            return getNoDataUI(context: context);
          case NotifierState.error:
            return getErrorUI(context: context);
        }
      },
    );
  }
}

class PageStoryContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ph = context.percentHeight;
    final captionController =
        Provider.of<StoryCaptionController>(context, listen: false);
    final projectsController =
        Provider.of<ProjectListController>(context, listen: false);
    final projects = getProjectNames(projectsController.model);
    final captions = getCaptions(captionController.model);

    final pickimagePH = Icon(
      Icons.add_a_photo_outlined,
      size: ph * 10,
      color: Colors.black.withOpacity(0.5),
    ).centered();

    return Consumer<StoryController>(
      builder: (_, storyController, __) {
        return VStack([
          HeightBox(ph * 2),
          VxCard(
            storyController.model.pic == null
                ? VxBox(child: pickimagePH)
                    .width(double.maxFinite)
                    .height(ph * 25)
                    .make()
                : Image.file(
                    File(storyController.model.pic),
                    height: ph * 25,
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                  ),
          ).roundedSM.elevation(8.0).clip(Clip.antiAlias).make().onTap(
            () async {
              final image =
                  await ImagePicker().getImage(source: ImageSource.gallery);
              storyController.model.pic = image.path;
              storyController.refresh();
            },
          ),
          HeightBox(ph * 6),
          _getDropdownTitle(title: 'Select My Project'),
          CustomDropdownButton(
            hint: 'Select a Project',
            options: projects.keys.toList(),
            value: storyController?.model?.stName,
            onChanged: (value) {
              storyController.model.stName = value;
              storyController.model.pId = projects[value];
              storyController.refresh();
            },
          ),
          HeightBox(ph * 4),
          _getDropdownTitle(title: 'Select Caption'),
          CustomDropdownButton(
            hint: 'Select a Caption',
            options: captions.keys.toList(),
            value: getValueFromMap(storyController.model.caption, captions),
            onChanged: (value) {
              storyController.model.caption = captions[value];
              storyController.refresh();
            },
          ),
          HeightBox(ph * 5),
          getButtonUI(context: context, storyController: storyController),
        ]).p12();
      },
    );
  }

  Widget _getDropdownTitle({@required String title}) {
    return title.text.color(kColorPrimary).xl.make();
  }

  // ignore: missing_return
  Widget getButtonUI({
    @required BuildContext context,
    @required StoryController storyController,
  }) {
    assert(storyController != null);
    assert(context != null);
    switch (storyController.state) {
      case NotifierState.initial:
        return _button(context: context, storyController: storyController);
      case NotifierState.fetching:
        return getPlatformProgress();
      case NotifierState.loaded:
        storyController.reset();
        return _button(context: context, storyController: storyController);
      case NotifierState.noData:
        return _button(context: context, storyController: storyController);
      case NotifierState.error:
        return _button(context: context, storyController: storyController);
    }
  }

  Widget _button({
    @required BuildContext context,
    @required StoryController storyController,
  }) =>
      CustomButton(
        callback: () {
          final attribute = storyController.model;
          if (attribute.caption == null) {
            showSnackbar(context: context, message: 'Please select a Caption!');
          } else if (attribute.pId == null) {
            showSnackbar(context: context, message: 'Please select a Project!');
          } else if (attribute.pic == null) {
            showSnackbar(context: context, message: 'Please select an Image!');
          }
        },
        title: kButtonSubmit,
      );
}
