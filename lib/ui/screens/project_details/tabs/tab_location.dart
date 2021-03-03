import 'package:flutter/material.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/controllers/project_detail_controller.dart';
import 'package:gmt_planter/helper/ui_helper.dart';
import 'package:gmt_planter/ui/common_widget/title_value_column.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class TabLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ProjectDetailController>(context, listen: false).model.data;
    final plantingArea = '${model.plantationSize} Hectare(s)';
    final density = '${model.plantingDensity} Trees/Hectare';
    return VStack(
      [
        VxBox(child: VxCard(getImage(path: kimageMap)).clip(Clip.antiAlias).rounded.make().p24())
            .width(context.screenWidth)
            .height(context.screenHeight * 0.3)
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
