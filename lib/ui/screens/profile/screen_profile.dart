import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gmt_planter/prefs/shared_prefs.dart';
import 'package:gmt_planter/router/router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/controllers/profile_controller.dart';
import 'package:gmt_planter/helper/platform_widgets.dart';
import 'package:gmt_planter/helper/ui_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/ui/common_widget/custom_button.dart';
import 'package:gmt_planter/ui/common_widget/custom_text_form_field.dart';

import '../../../prefs/shared_prefs.dart';

class ScreenProfile extends StatelessWidget {
  static const id = 'profile';
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (_, profileController, __) {
        return Scaffold(
          appBar: customAppbar(
            title: 'Profile',
            actions: [
              if (profileController.model == null)
                Container()
              else
                IconButton(
                  icon: Icon(profileController.isEditing ? Icons.close : Icons.edit),
                  onPressed: () =>
                      profileController.setIsEditing(value: !profileController.isEditing),
                ),
              IconButton(
                onPressed: () => launchProjectStoryList(context: context),
                icon: const Icon(Icons.list_rounded),
              ),
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: () => launchFundHistory(context: context),
              )
            ],
          ),
          body: Builder(
            builder: (ctx) => getBody(
              ctx,
              profileController,
              () {
                // if (profileController.file != null) {
                //   final size = getFileSize(profileController.file);
                //   if (size > 5) {
                //     showSnackbar(context: ctx, message: "File size can't exceed 5 MBs!");
                //     return;
                //   }
                // }
                profileController.updateInfo(context: context).then((value) {
                  if (value) {
                    showSnackbar(
                      context: ctx,
                      message: 'Profile updated successfully.',
                      color: Colors.green,
                    );
                  } else {
                    showSnackbar(
                      context: ctx,
                      message: 'Unable to update profile! Please try again.',
                    );
                  }
                });
              },
            ),
          ),
        );
      },
    );
  }

  // ignore: missing_return
  Widget getBody(BuildContext context, ProfileController controller, VoidCallback callback) {
    switch (controller.state) {
      case NotifierState.initial:
        controller.getInfo(context: context);
        return getPlatformProgress();
      case NotifierState.fetching:
        return getPlatformProgress();
      case NotifierState.loaded:
        return _ProfileUI(callback: callback);
      case NotifierState.noData:
        return controller.model == null
            ? getNoDataUI(context: context)
            : _ProfileUI(callback: callback);
      case NotifierState.error:
        return controller.model == null
            ? getErrorUI(context: context, callback: () => controller.getInfo(context: context))
            : _ProfileUI(callback: callback);
    }
  }
}

class _ProfileUI extends HookWidget {
  final VoidCallback callback;
  static final _formKey = GlobalKey<FormState>();

  const _ProfileUI({@required this.callback});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProfileController>(context, listen: false);
    final model = controller.model.data;
    final ph = context.percentHeight;
    final phoneNode = useFocusNode();
    return Form(
      key: _formKey,
      child: VStack([
        HeightBox(ph * 2),
        _ProfilePicUI(),
        HeightBox(ph * 4),
        _CounterUI(),
        HeightBox(ph * 4),
        _getContentRow(
          context: context,
          title: 'Username',
          value: model.email,
        ),
        HeightBox(ph * 2),
        FutureBuilder<String>(
          future: getPassword(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return _getContentRow(
                context: context,
                title: 'Password',
                value: snapshot?.data ?? '',
              );
            } else {
              return Container(height: 50);
            }
          },
        ),
        HeightBox(ph * 2),
        _getContentRow(
          context: context,
          title: 'Total Funds',
          value: model.totalFunds,
        ),
        HeightBox(ph * 2),
        _getContentRow(
          context: context,
          title: 'Phone',
          value: model.phoneNo,
          inputType: TextInputType.number,
          inputAction: TextInputAction.next,
          myNode: phoneNode,
          enabled: controller.isEditing,
          isMandatory: true,
          onSave: (s) => controller.model.data.phoneNo = s,
        ),
        HeightBox(ph * 8),
        if (controller.isEditing)
          CustomButton(
            title: kButtonSubmit,
            callback: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                callback();
              }
            },
          ),
        HeightBox(ph * 8),
      ]).px12().scrollVertical(),
    );
  }

  Widget _getContentRow({
    @required BuildContext context,
    @required String title,
    @required String value,
    String prefix,
    TextInputType inputType,
    TextInputAction inputAction,
    FocusNode myNode,
    FocusNode nextNode,
    Function(String) onSave,
    bool isMandatory = false,
    bool enabled = false,
  }) {
    return HStack([
      Expanded(child: title.text.center.gray800.make()),
      Expanded(
        flex: 2,
        child: CustomTextFormField(
          context: context,
          hint: 'Enter $title',
          initialValue: value,
          inputAction: inputAction,
          myNode: myNode,
          onSave: onSave,
          inputType: inputType,
          isMandatory: isMandatory,
          prefilledText: prefix,
          nextNode: nextNode,
          showTitle: false,
          isEnabled: enabled,
        ),
      )
    ]);
  }
}

class _ProfilePicUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ph = context.percentHeight;
    final notifier = Provider.of<ProfileController>(context, listen: false);
    return VxBox(
      child: FutureBuilder<String>(
        future: getProfileImage(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Icon(
              Icons.person,
              size: ph * 10,
              color: Colors.white,
            ).centered();
          } else {
            return VxCard(Image.file(File(snapshot.data), fit: BoxFit.cover)).circular.make().p1();
          }
        },
      ),
    ).roundedFull.width(ph * 15).height(ph * 15).color(kColorPrimaryDark).makeCentered().onTap(() {
      if (!notifier.isEditing) return;
      showImageSourceBottomSheet(
        context: context,
        callback: (source) async {
          if (source != null) {
            final image = await ImagePicker().getImage(source: source);
            if (image != null) {
              notifier.changeImage(File(image.path));
            }
          }
        },
      );
    });
  }
}

class _CounterUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: getStoryCounter(),
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;
        return VStack(
          [
            count.toString().text.xl6.bold.green400.make(),
            4.heightBox,
            'stories posted'.text.xl2.semiBold.letterSpacing(1.2).green400.make(),
          ],
          crossAlignment: CrossAxisAlignment.center,
        ).centered();
      },
    );
  }
}
