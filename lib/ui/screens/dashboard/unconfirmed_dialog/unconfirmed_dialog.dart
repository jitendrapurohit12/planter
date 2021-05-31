import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/controllers/receipt_controller.dart';
import 'package:gmt_planter/controllers/unconfirmed_funds_controller.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/helper/platform_widgets.dart';
import 'package:gmt_planter/helper/ui_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
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
    final controller = usePageController(viewportFraction: 0.8);

    return VStack(
      [
        Expanded(
          child: Consumer<UnconfirmedFundsController>(builder: (_, notifier, __) {
            if (notifier.model.data.isEmpty) {
              performAfterDelay(callback: () => callback());
              return Container();
            }
            return PageView.builder(
              controller: controller,
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
                        VxBox(child: projectImageWidget)
                            .height(ph * 10)
                            .width(pw * 20)
                            .roundedLg
                            .make(),
                        pw.widthBox,
                        model.project.name.text.semiBold.gray600
                            .letterSpacing(2)
                            .wordSpacing(4)
                            .makeCentered()
                            .expand(),
                      ]),
                    ).gray100.roundedSM.make().px8(),
                    const Spacer(),
                    '\$ ${model.amount}'.text.xl5.semiBold.makeCentered(),
                    const Spacer(),
                    Consumer<ReceiptController>(
                      builder: (_, controller, child) {
                        controller.model.fundId = model.id;
                        controller.model.projectId = model.projectId;
                        switch (controller.state) {
                          case NotifierState.fetching:
                            return getPlatformProgress().pOnly(bottom: 16);
                          case NotifierState.loaded:
                            notifier.removeItem(index);
                            controller.reset();
                            return Container();
                          case NotifierState.error:
                            return child;
                          default:
                            return child;
                        }
                      },
                      child: HStack(
                        [
                          CustomRectangleButton(
                            color: Colors.green,
                            title: kButtonConfirm.toUpperCase(),
                            fontSize: 13,
                            letterSpacing: 1,
                            padding: 10,
                            callback: () async {
                              final result = await launchReceipt(
                                context: context,
                                data: model,
                                status: kStatusAccepted,
                              );
                              if (result == null) {
                                return;
                              } else {
                                notifier.removeItem(index);
                              }
                            },
                          ).expand(),
                          CustomRectangleButton(
                            title: kButtonReject.toUpperCase(),
                            fontSize: 13,
                            letterSpacing: 1,
                            padding: 10,
                            callback: () async {
                              final result = await launchReceipt(
                                context: context,
                                data: model,
                                status: kStatusRejected,
                              );
                              if (result == null) {
                                return;
                              } else {
                                notifier.removeItem(index);
                              }
                            },
                          ).expand(),
                        ],
                      ),
                    ),
                  ]),
                ).width(pw * 90).height(ph * 60).make())
                    .roundedSM
                    .px8
                    .makeCentered();
              },
              itemCount: notifier.model.data.length,
            );
          }),
        ),
        // SizedBox(
        //   width: double.maxFinite,
        //   child: CustomRectangleButton(
        //     callback: callback,
        //     title: 'CANCEL',
        //   ),
        // ),
      ],
    );
  }
}
