import 'package:flutter/material.dart';
import 'package:gmt_planter/controllers/fund_history_notifier.dart';
import 'package:gmt_planter/helper/platform_widgets.dart';
import 'package:gmt_planter/helper/ui_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/ui/common_widget/title_value_column.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class ScreenFundHistory extends StatelessWidget {
  static const id = 'fund_history';
  const ScreenFundHistory({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: 'Funds History'.text.make()),
      body: Consumer<FundHistoryNotifier>(
        builder: (context, value, child) {
          switch (value.state) {
            case NotifierState.initial:
              value.fetchFundHIstory(context);
              return getPlatformProgress();
            case NotifierState.loaded:
              return _FundList();
            case NotifierState.noData:
              return getNoDataUI(context: context);
            case NotifierState.error:
              return getErrorUI(context: context, callback: () => value.fetchFundHIstory(context));
            default:
              return getPlatformProgress();
          }
        },
      ),
    );
  }
}

class _FundList extends StatelessWidget {
  const _FundList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = Provider.of<FundHistoryNotifier>(context).model.items;
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final model = list[index];
        return ExpansionTile(
          title: model.projectName.text.make(),
          subtitle: model.amountPaid.text.make(),
          children: [
            TitleValueColumn(title: 'Created At', value: model.createdAt),
            TitleValueColumn(title: 'Partner Name', value: model.partnerName),
            TitleValueColumn(title: 'Planter User', value: model.planterUser),
            TitleValueColumn(title: 'Remark', value: model.remark),
            TitleValueColumn(title: 'Status', value: model.status),
            SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
