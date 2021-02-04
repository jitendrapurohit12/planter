import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/controllers/unconfirmed_funds_controller.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/helper/ui_helper.dart';
import 'package:gmt_planter/router/router.dart';
import 'package:gmt_planter/ui/common_widget/custom_rectangle_button.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class UnconfirmedDialog extends HookWidget {
  final VoidCallback callback;

  const UnconfirmedDialog(this.callback);
  @override
  Widget build(BuildContext context) {
    final ph = context.percentHeight;
    final pw = context.percentWidth;

    return VStack([
      Expanded(
        child: Consumer<UnconfirmedFundsController>(builder: (_, notifier, __) {
          if (notifier.model.data.isEmpty) {
            performAfterDelay(callback: () => callback());
          }
          return PageView.builder(
            itemBuilder: (_, index) {
              final model = notifier.model.data[index];
              final projectURL = model.project.thumbnailUrl;
              //final receiptURL = notifier.model.data[index].pic;
              final projectImageWidget =
                  VxCard(getCachedImage(path: projectURL)).elevation(0).make();
              return VxCard(VxBox(
                      child: VStack([
                ph.heightBox,
                VxBox(
                    child: HStack([
                  VxBox(child: projectImageWidget).height(ph * 10).width(pw * 20).roundedLg.make(),
                  pw.widthBox,
                  model.project.name.text.semiBold.gray600
                      .letterSpacing(2)
                      .wordSpacing(4)
                      .makeCentered()
                      .expand(),
                ])).gray100.roundedSM.make().px8(),
                const Spacer(),
                '\$ ${model.amount}'.text.xl6.bold.makeCentered(),
                const Spacer(),
                HStack([
                  CustomRectangleButton(
                    color: Colors.green,
                    title: kButtonConfirm.toUpperCase(),
                    fontSize: 13,
                    letterSpacing: 1,
                    padding: 4,
                    callback: () async {
                      final result = await launchReceipt(context: context, data: model);
                      if (result) notifier.removeItem(index);
                    },
                  ).expand(),
                  CustomRectangleButton(
                    title: kButtonReject.toUpperCase(),
                    fontSize: 13,
                    letterSpacing: 1,
                    padding: 4,
                    callback: () => notifier.removeItem(index),
                  ).expand(),
                ])
              ])).width(pw * 90).height(ph * 60).make())
                  .roundedSM
                  .makeCentered();
            },
            itemCount: notifier.model.data.length,
          );
        }),
      ),
      SizedBox(
        width: double.maxFinite,
        child: CustomRectangleButton(
          callback: callback,
          title: 'CANCEL',
        ),
      ),
    ]);
  }
}
