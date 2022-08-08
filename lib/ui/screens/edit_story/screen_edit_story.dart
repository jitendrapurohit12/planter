import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/controllers/caption_controller.dart';
import 'package:gmt_planter/controllers/project_list_controller.dart';
import 'package:gmt_planter/controllers/story_controller.dart';
import 'package:gmt_planter/controllers/story_update_controller.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/helper/platform_widgets.dart';
import 'package:gmt_planter/helper/ui_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/models/project_story_list_model.dart';
import 'package:gmt_planter/models/story_model.dart';
import 'package:gmt_planter/models/story_update_model.dart';
import 'package:gmt_planter/router/router.dart';
import 'package:gmt_planter/ui/common_widget/custom_button.dart';
import 'package:gmt_planter/ui/common_widget/custom_dropdown_button.dart';
import 'package:gmt_planter/ui/common_widget/image_picker_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class ScreenEditStory extends StatelessWidget {
  static const id = 'story_update_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(title: 'Edit Story'),
      body: PageStoryContent(),
    );
  }
}

class PageStoryContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ph = context.percentHeight;

    final args = ModalRoute.of(context).settings.arguments as Map<String, Story>;

    final arg = args['model'];

    return Consumer2<StoryUpdateController, CaptionController>(
      builder: (ctx, storyController, captionController, __) {
        switch (captionController.state) {
          case NotifierState.initial:
            captionController.fetchCaptions(context);
            break;
          case NotifierState.fetching:
            return getPlatformProgress();
          case NotifierState.fetchingMore:
          case NotifierState.loaded:
            break;
          case NotifierState.noData:
            break;
          case NotifierState.error:
            showSnackbar(context: context, message: captionController.error.message);
            return getErrorUI(context: context);
        }
        return SingleChildScrollView(
          child: VStack([
            HeightBox(ph * 2),
            ImagePickerUI(
              file: storyController.file,
              url: arg.thumbnailUrl,
              callback: (_) async {
                showImageSourceBottomSheet(
                  context: context,
                  callback: (source) async {
                    if (ImageSource.camera == source) {
                      performAfterDelay(
                        callback: () async {
                          final path = await launchCamera(context: context);
                          if (path != null) {
                            storyController.changeImage(File(path));
                          }
                        },
                      );
                    } else if (ImageSource.gallery == source) {
                      final image = await ImagePicker().pickImage(source: source);
                      if (image != null) storyController.changeImage(File(image.path));
                    }
                  },
                );
              },
            ),
            HeightBox(ph * 6),
            _getDropdownTitle(title: 'Select Caption'),
            CustomDropdownButton(
              hint: 'Select a Caption',
              options: captionController.captions.keys.toList(),
              value: getValueFromMap(
                  storyController.model.caption ?? arg.captionId, captionController.captions),
              onChanged: (value) {
                storyController.model.caption = captionController.captions[value];
                storyController.refresh();
              },
            ),
            HeightBox(ph * 5),
            getButtonUI(context: context, storyController: storyController),
          ]).p12(),
        );
      },
    );
  }

  Widget _getDropdownTitle({@required String title}) {
    return title.text.color(kColorPrimary).xl.make();
  }

  // ignore: missing_return
  Widget getButtonUI({
    @required BuildContext context,
    @required StoryUpdateController storyController,
  }) {
    assert(storyController != null);
    assert(context != null);
    switch (storyController.state) {
      case NotifierState.initial:
        return _button(context: context, storyController: storyController);
      case NotifierState.fetching:
        return getPlatformProgress();
      case NotifierState.fetchingMore:
      case NotifierState.loaded:
        increasePostStoryCounter();
        showSnackbar(
          context: context,
          message: 'Story updated successfully.',
          color: Colors.green,
        );
        performAfterDelay(callback: () => Navigator.pop(context));
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
    @required StoryUpdateController storyController,
  }) =>
      CustomButton(
        callback: () {
          if (storyController.model.caption == null) {
            showSnackbar(context: context, message: 'Please select a Caption!');
            return;
          }

          if (storyController.file != null) {
            final size = getFileSize(storyController.file);

            if (size > 5) {
              showSnackbar(context: context, message: "File size can't exceed 5 MBs!");
              return;
            }
          }

          storyController.postStory(context: context);
        },
        title: kButtonSubmit,
      );
}
