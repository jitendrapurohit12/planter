import 'package:flutter/material.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/controllers/project_detail_controller.dart';
import 'package:gmt_planter/ui/common_widget/title_value_column.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class TabLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model =
        Provider.of<ProjectDetailController>(context, listen: false).model.data;
    final plantingArea = '${model.plantationSize} Hectare(s)';
    final density = '${model.plantingDensity} Trees/Hectare';
    return VStack(
      [
        VxCard(VxBox()
                .height(100)
                .width(context.screenWidth * 0.5)
                .color(kColorPrimary)
                .make())
            .elevation(8.0)
            .roundedSM
            .make(),
        const HeightBox(16),
        TitleValueColumn(
          title: kPlantingArea,
          value: plantingArea,
        ),
        TitleValueColumn(
          title: kDensity,
          value: density,
        ),
        TitleValueColumn(
          title: kTotalTrees,
          value: model.totalNoOfTrees.toString(),
        ),
        const HeightBox(36),
      ],
      crossAlignment: CrossAxisAlignment.center,
    ).scrollVertical();
  }
}
