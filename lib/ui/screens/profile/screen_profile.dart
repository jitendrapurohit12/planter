import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/controllers/profile_controller.dart';
import 'package:gmt_planter/helper/platform_widgets.dart';
import 'package:gmt_planter/helper/ui_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/ui/common_widget/custom_button.dart';
import 'package:gmt_planter/ui/common_widget/custom_textfield.dart';

class ScreenProfile extends StatelessWidget {
  static const id = 'profile';
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (_, profileController, __) {
        return Scaffold(
          appBar: customAppbar(
              title: 'Profile',
              actions: profileController.model == null
                  ? null
                  : [
                      IconButton(
                        icon: Icon(profileController.isEditing
                            ? Icons.close
                            : Icons.edit),
                        onPressed: () => profileController.setIsEditing(
                            value: !profileController.isEditing),
                      )
                    ]),
          body: getBody(
            context,
            profileController,
            () {
              if (profileController.file != null) {
                final size = getFileSize(profileController.file);
                if (size > 5) {
                  showSnackbar(
                      context: context,
                      message: "File size can't exceed 5 MBs!");
                  return;
                }
              }
              profileController.updateInfo(context: context);
            },
          ),
        );
      },
    );
  }

  // ignore: missing_return
  Widget getBody(BuildContext context, ProfileController controller,
      VoidCallback callback) {
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
        if (controller.error.code == kErrorUnauthorised) {
          logout(context: context);
        }
        return controller.model == null
            ? getErrorUI(context: context)
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
    final fundsNode = useFocusNode();
    final nameNode = useFocusNode();
    final phoneNode = useFocusNode();
    final addressNode = useFocusNode();
    final bankNameNode = useFocusNode();
    final accNoNode = useFocusNode();
    final branchNode = useFocusNode();
    return Form(
      key: _formKey,
      child: VStack([
        HeightBox(ph * 2),
        _ProfilePicUI(),
        HeightBox(ph * 4),
        _getTitle(title: 'Personal Info'),
        HeightBox(ph * 2),
        _getContentRow(
          context: context,
          title: 'Funds',
          value: model.totalFunds.toString(),
          prefix: '\$ ',
          inputType: TextInputType.number,
          inputAction: TextInputAction.next,
          myNode: fundsNode,
          nextNode: nameNode,
          enabled: controller.isEditing,
          onSave: (s) => controller.model.data.totalFunds = int.parse(s),
        ),
        _getContentRow(
          context: context,
          title: 'Name',
          value: '${model.firstName} ${model.lastName}',
          inputAction: TextInputAction.next,
          myNode: nameNode,
          nextNode: phoneNode,
          enabled: controller.isEditing,
          onSave: (s) {
            final names = s?.split(' ');
            controller.model.data.firstName = names[0];
            if (names.length == 2) controller.model.data.lastName = names[1];
          },
        ),
        _getContentRow(
          context: context,
          title: 'Phone',
          value: model.phoneNo,
          inputType: TextInputType.number,
          inputAction: TextInputAction.next,
          myNode: phoneNode,
          nextNode: addressNode,
          enabled: controller.isEditing,
          onSave: (s) => controller.model.data.phoneNo = s,
        ),
        _getContentRow(
          context: context,
          title: 'Address',
          value: model.addr,
          inputAction: TextInputAction.next,
          myNode: addressNode,
          nextNode: bankNameNode,
          enabled: controller.isEditing,
          onSave: (s) => controller.model.data.addr = s,
        ),
        HeightBox(ph * 4),
        _getTitle(title: 'Bank Details'),
        HeightBox(ph * 2),
        _getContentRow(
          context: context,
          title: 'Name',
          value: model.bankDetails[0].bankName,
          inputAction: TextInputAction.next,
          myNode: bankNameNode,
          nextNode: accNoNode,
          enabled: controller.isEditing,
          onSave: (s) => controller.model.data.bankDetails[0].bankName = s,
        ),
        _getContentRow(
          context: context,
          title: 'Acc. No.',
          value: model.bankDetails[0].accNo.toString(),
          inputType: TextInputType.number,
          inputAction: TextInputAction.next,
          myNode: accNoNode,
          nextNode: branchNode,
          enabled: controller.isEditing,
          onSave: (s) =>
              controller.model.data.bankDetails[0].accNo = int.parse(s),
        ),
        _getContentRow(
          context: context,
          title: 'Branch',
          value: model.bankDetails[0].branch,
          inputAction: TextInputAction.done,
          myNode: branchNode,
          enabled: controller.isEditing,
          onSave: (s) => controller.model.data.bankDetails[0].branch = s,
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
    @required TextInputAction inputAction,
    @required FocusNode myNode,
    FocusNode nextNode,
    @required Function(String) onSave,
    bool isMandatory = true,
    bool enabled = true,
  }) {
    return HStack([
      Expanded(child: title.text.center.gray600.light.make()),
      Expanded(
        flex: 2,
        child: CustomTextfield(
          context: context,
          hint: 'Enter $title',
          align: TextAlign.center,
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

  Widget _getTitle({@required String title}) {
    return title.text.color(kColorPrimary).xl.make();
  }
}

class _ProfilePicUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ph = context.percentHeight;
    final notifier = Provider.of<ProfileController>(context, listen: false);
    Widget child;
    if (notifier.file != null) {
      child = VxCard(Image.file(notifier.file, fit: BoxFit.cover))
          .circular
          .make()
          .p1();
    } else if (notifier.model?.data?.pic != null) {
      child = VxCard(getCachedImage(path: notifier.model.data.pic))
          .circular
          .make()
          .p1();
    } else {
      child = Icon(
        Icons.person,
        size: ph * 10,
        color: Colors.white,
      ).centered();
    }
    return VxBox(child: child)
        .roundedFull
        .width(ph * 15)
        .height(ph * 15)
        .color(kColorPrimaryDark)
        .makeCentered()
        .onTap(() async {
      if (!notifier.isEditing) return;
      final image = await ImagePicker().getImage(source: ImageSource.gallery);
      if (image != null) {
        notifier.changeImage(File(image.path));
      }
    });
  }
}
