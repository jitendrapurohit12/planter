import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/controllers/project_detail_controller.dart';
import 'package:gmt_planter/ui/common_widget/animated_progress.dart';
import 'package:gmt_planter/ui/common_widget/title_value_column.dart';
import 'package:gmt_planter/ui/common_widget/title_value_row.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class TabDetails extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ProjectDetailController>(context, listen: false);
    final model = notifier.model.data;
    final femaleEmployment = '${model.femaleEmpTarget} %';
    //final fundsForPlanning = '\$ ${model.projectImpactQty}';
    //final fundsForConservation = '\$ ${model.conservationBalance}';
    final fundDenominator = notifier.totalQty;
    final fundNumerator = notifier.boughtQty;
    //if (fundDenominator == 0) fundDenominator = 1;
    final fundsRatio = fundNumerator / fundDenominator;
    final fundsRatioString = '$fundNumerator/$fundDenominator (${notifier.completion})';

    final controller = useStreamController<double>();
    Future.delayed(const Duration(milliseconds: 500), () => controller.add(fundsRatio));

    return VStack([
      TitleValueRow(title: 'Impact Inventory', value: fundsRatioString),
      AnimatedProgress(controller: controller),
      const HeightBox(16),
      TitleValueColumn(
        title: kCommunity,
        value: model.community,
      ),
      TitleValueColumn(
        title: kFemaleEmpTArget,
        value: femaleEmployment,
      ),
      //  TitleValueColumn(
      //    title: kTargetFundsForPlanning,
      //    value: fundsForPlanning,
      //  ),
      //  TitleValueColumn(
      //    title: kTargetFundsForConservation,
      //    value: fundsForConservation,
      //  ),
      const HeightBox(36),
    ]).scrollVertical();
  }
}
