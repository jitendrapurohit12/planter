import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/controllers/receipt_controller.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/helper/platform_widgets.dart';
import 'package:gmt_planter/helper/ui_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/models/unconfirmed_funds_model.dart';
import 'package:gmt_planter/ui/common_widget/custom_text_field.dart';
import 'package:gmt_planter/ui/common_widget/image_picker_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class ScreenReciept extends StatelessWidget {
  static const id = 'receipt';
  @override
  Widget build(BuildContext context) {
    final ph = context.percentHeight;
    final pw = context.percentWidth;
    final args = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final model = args['data'] as Data;
    final status = args['status'] as String;
    final projectURL = model.project.thumbnailUrl;
    final projectImageWidget = VxCard(getCachedImage(path: projectURL)).elevation(0).make();
    return Consumer<ReceiptController>(builder: (_, notifier, __) {
      notifier.model.fundId = model.id;
      notifier.model.projectId = model.projectId;
      return Scaffold(
        appBar: customAppbar(title: 'Upload Receipt'),
        body: VStack([
          VxBox(
              child: HStack([
            VxBox(child: projectImageWidget).height(ph * 12).width(pw * 25).p3.roundedLg.make(),
            pw.widthBox,
            model.project.name.text.semiBold.xl.gray600
                .letterSpacing(2)
                .wordSpacing(4)
                .makeCentered()
                .expand(),
          ])).gray300.roundedSM.make().p8(),
          ImagePickerUI(
              file: notifier.file,
              subtitle: 'Add Receipt',
              infiniteHeight: true,
              elevation: 0.0,
              callback: (context) async {
                showImageSourceBottomSheet(
                    context: context,
                    callback: (source) async {
                      if (source != null) {
                        final image = await ImagePicker().getImage(source: source);
                        if (image != null) {
                          notifier.changeImage(File(image.path));
                          notifier.refresh();
                        }
                      }
                    });
              }).p4().expand(),
          (ph * 2).heightBox,
          Builder(
            // ignore: missing_return
            builder: (ctx) {
              switch (notifier.state) {
                case NotifierState.initial:
                  return VxBox(child: _SubmitUI(model, status)).height(ph * 20).make();
                case NotifierState.fetching:
                  return getPlatformProgress();
                case NotifierState.loaded:
                  performAfterDelay(callback: () => notifier.reset());
                  performAfterDelay(callback: () async {
                    showSnackbar(
                      context: ctx,
                      message: 'Receipt uploaded successfully',
                      color: Colors.green,
                    );
                    await Future.delayed(const Duration(seconds: 2));
                    performAfterDelay(callback: () => Navigator.pop(context, true));
                  });

                  return Container();
                case NotifierState.error:
                  Widget child;
                  if (notifier.error.code == kErrorUnauthorisedFund) {
                    performAfterDelay(callback: () {
                      print('unath');
                      showSnackbar(context: context, message: notifier.error.message);
                      Navigator.pop(context, false);
                    });
                    child = VxBox(child: _SubmitUI(model, status)).height(ph * 20).make();
                  } else {
                    performAfterDelay(
                      callback: () => showSnackbar(
                        context: ctx,
                        message: 'Some error occured! Please try again.',
                      ),
                    );
                    child = VxBox(child: _SubmitUI(model, status)).height(ph * 20).make();
                  }
                  return child;
                case NotifierState.noData:
                  performAfterDelay(
                    callback: () => showSnackbar(
                      context: ctx,
                      message: 'Some error occured! Please try again.',
                    ),
                  );
                  return VxBox(child: _SubmitUI(model, status)).height(ph * 20).make();
              }
            },
          ),
        ]),
      );
    });
  }
}

class _SubmitUI extends HookWidget {
  final Data model;
  final String status;

  const _SubmitUI(this.model, this.status);
  @override
  Widget build(BuildContext context) {
    final pw = context.percentWidth;
    final ph = context.percentHeight;
    final notifier = Provider.of<ReceiptController>(context, listen: false);
    return VStack([
      CustomTextfield(
        context: context,
        hint: 'Enter Remark',
        inputAction: TextInputAction.done,
        maxLines: 2,
        isMandatory: false,
        myNode: useFocusNode(),
        onChanged: (s) => notifier.model.remark = s,
      ).px12(),
      (ph * 2).heightBox,
      HStack(
        [
          (pw * 3).widthBox,
          Expanded(
            child: CustomTextfield(
              context: context,
              hint: 'Enter Amount',
              initialValue: model.amount,
              formatters: [doubleFormatter],
              inputAction: TextInputAction.done,
              leadingIcon: const Icon(Icons.attach_money),
              myNode: useFocusNode(),
              isEnabled: false,
              inputType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ),
          (pw * 4).widthBox,
          FloatingActionButton.extended(
            onPressed: () {
              if (notifier.file == null) {
                showSnackbar(context: context, message: 'Please pick image to submit!');
                return;
              }

              final size = getFileSize(notifier.file);

              if (size > 5) {
                showSnackbar(context: context, message: "File size can't exceed 5 MBs!");
                return;
              }

              notifier.model.status = status;

              notifier.postReceipt(context: context);
            },
            icon: const Icon(Icons.done),
            label: getPaymentButtonTitle(status).toUpperCase().text.sm.bold.make(),
          ),
          (pw * 3).widthBox,
        ],
      ),
    ]);
  }
}
