import 'package:flutter/material.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/ui/common_widget/custom_button.dart';
import 'package:gmt_planter/ui/common_widget/image_picker_ui.dart';
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

    return Consumer<StoryController>(
      builder: (_, storyController, __) {
        return VStack([
          HeightBox(ph * 2),
          ImagePickerUI(
              file: storyController.file,
              callback: (image) {
                storyController.changeImage(image);
                storyController.refresh();
              }),
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
        showSnackbar(
          context: context,
          message: 'Story uploaded successfully.',
          color: Colors.green,
        );
        storyController.reset();
        return Container();
      case NotifierState.noData:
        return _button(context: context, storyController: storyController);
      case NotifierState.error:
        showSnackbar(context: context, message: storyController.error.message);
        storyController.reset();
        return getErrorUI(context: context);
    }
  }

  Widget _button({
    @required BuildContext context,
    @required StoryController storyController,
  }) =>
      CustomButton(
        callback: () {
          if (storyController.model.caption == null) {
            showSnackbar(context: context, message: 'Please select a Caption!');
            return;
          } else if (storyController.model.pId == null) {
            showSnackbar(context: context, message: 'Please select a Project!');
            return;
          } else if (storyController.file == null) {
            showSnackbar(context: context, message: 'Please select an Image!');
            return;
          }

          final size = getFileSize(storyController.file);

          if (size > 5) {
            showSnackbar(
                context: context, message: "File size can't exceed 5 MBs!");
            return;
          }

          storyController.postStory(context: context);
        },
        title: kButtonSubmit,
      );
}
