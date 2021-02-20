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
    final projectURL = model.project.thumbnailUrl;
    final projectImageWidget = VxCard(getCachedImage(path: projectURL)).elevation(0).make();
    return Consumer<ReceiptController>(builder: (_, notifier, __) {
      notifier.model.fundId = model.id;
      notifier.model.projectId = model.projectId;
      return Scaffold(
        appBar: customAppbar(title: 'Upload Receipt'),
        body: ZStack([
          VStack([
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
            (ph * 10).heightBox,
          ]),
          Positioned(
            bottom: ph * 2,
            left: 0,
            right: 0,
            child: Builder(
              // ignore: missing_return
              builder: (_) {
                switch (notifier.state) {
                  case NotifierState.initial:
                    return VxBox(child: _SubmitUI()).height(ph * 8).make();
                  case NotifierState.fetching:
                    return getPlatformProgress();
                  case NotifierState.loaded:
                    performAfterDelay(callback: () => notifier.reset());
                    performAfterDelay(callback: () async {
                      showSnackbar(
                        context: context,
                        message: 'Receipt uploaded successfully',
                        color: Colors.green,
                      );
                      await Future.delayed(2.seconds);
                      performAfterDelay(callback: () => Navigator.pop(context, true));
                    });

                    return Container();
                  case NotifierState.error:
                  case NotifierState.noData:
                    performAfterDelay(
                      callback: () => showSnackbar(
                        context: context,
                        message: 'Some error occured! Please try again.',
                      ),
                    );
                    return VxBox(child: _SubmitUI()).height(ph * 8).make();
                }
              },
            ),
          ),
        ]),
      );
    });
  }
}

class _SubmitUI extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final pw = context.percentWidth;
    final notifier = Provider.of<ReceiptController>(context, listen: false);
    return HStack(
      [
        (pw * 3).widthBox,
        Expanded(
          child: CustomTextfield(
            context: context,
            hint: 'Enter Amount',
            align: TextAlign.center,
            inputAction: TextInputAction.done,
            myNode: useFocusNode(),
            onChanged: (s) => notifier.model.amount = s.isEmpty ? null : int.parse(s),
            inputType: TextInputType.number,
          ),
        ),
        (pw * 4).widthBox,
        FloatingActionButton.extended(
          onPressed: () {
            if (notifier.file == null) {
              showSnackbar(context: context, message: 'Please pick image to submit!');
              return;
            } else if (notifier.model.amount == null) {
              showSnackbar(context: context, message: 'Please enter amount to submit!');
              return;
            }

            final size = getFileSize(notifier.file);

            if (size > 5) {
              showSnackbar(context: context, message: "File size can't exceed 5 MBs!");
              return;
            }

            notifier.postReceipt(context: context);
          },
          icon: const Icon(Icons.done_all),
          label: Text(kButtonSubmit.toUpperCase()),
        ),
        (pw * 3).widthBox,
      ],
    );
  }
}
