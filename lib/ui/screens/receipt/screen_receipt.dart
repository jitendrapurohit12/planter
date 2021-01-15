import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/controllers/receipt_controller.dart';
import 'package:gmt_planter/helper/ui_helper.dart';
import 'package:gmt_planter/style/text_styles.dart';
import 'package:gmt_planter/ui/common_widget/custom_textfield.dart';
import 'package:gmt_planter/ui/common_widget/image_picker_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class ScreenReciept extends StatelessWidget {
  static const id = 'receipt';
  @override
  Widget build(BuildContext context) {
    final ph = context.percentHeight;
    return Consumer<ReceiptController>(builder: (_, notifier, __) {
      return Scaffold(
        appBar: customAppbar(title: 'Upload Receipt'),
        body: ZStack([
          VStack([
            Text(
              'This is a long long long Project name. And dont include anything else.',
              style: receiptTitleStyle(context: context),
            ).p(ph * 2),
            ImagePickerUI(
              file: notifier.file,
              subtitle: 'Click the receipt',
              infiniteHeight: true,
              source: ImageSource.camera,
              callback: (image) {
                notifier.changeImage(image);
                notifier.refresh();
              },
            ).expand(),
            (ph * 10).heightBox,
          ]),
          Positioned(
              bottom: ph * 2,
              left: 0,
              right: 0,
              child: VxBox(child: _SubmitUI()).height(ph * 8).make()),
        ]),
      );
    });
  }
}

class _SubmitUI extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final pw = context.percentWidth;
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
            onSave: (s) {},
            inputType: TextInputType.number,
            showTitle: false,
            showHint: true,
          ),
        ),
        (pw * 4).widthBox,
        FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.done_all),
          label: Text(kButtonSubmit.toUpperCase()),
        ),
        (pw * 3).widthBox,
      ],
    );
  }
}
