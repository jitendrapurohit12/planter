import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/controllers/project_detail_controller.dart';
import 'package:gmt_planter/models/project_details_model.dart';
import 'package:gmt_planter/ui/common_widget/animated_progress.dart';
import 'package:gmt_planter/ui/common_widget/title_value_column.dart';
import 'package:gmt_planter/ui/common_widget/title_value_row.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class TabDetails extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final model =
        Provider.of<ProjectDetailController>(context, listen: false).model.data;
    final femaleEmployment = '${model.femaleEmpTarget} %';
    final fundsForPlanning = '\$ ${model.totalFundingTarget}';
    final fundsForConservation = '\$ ${model.conservationBalance}';
    final fundDenominator =
        model.totalFundingTarget + model.conservationBalance;
    final fundNumerator = model.fundsRaised;
    final fundsRatio = (fundNumerator / fundDenominator).toDouble();
    final fundsRatioString = '$fundNumerator/$fundDenominator';

    final controller = useStreamController<double>();
    Future.delayed(500.milliseconds, () => controller.add(fundsRatio));

    return VStack([
      TitleValueRow(title: 'Fund Raised', value: fundsRatioString),
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
      TitleValueColumn(
        title: kTargetFundsForPlanning,
        value: fundsForPlanning,
      ),
      TitleValueColumn(
        title: kTargetFundsForConservation,
        value: fundsForConservation,
      ),
      const HeightBox(36),
    ]).scrollVertical();
  }
}

double _getFundRatio(Data model) {
  final denominator = model.totalFundingTarget + model.conservationBalance;
  final numerator =
      model.fundsRaised == 0 ? denominator * 0.8 : model.fundsRaised;

  return (numerator / denominator).toDouble();
}
