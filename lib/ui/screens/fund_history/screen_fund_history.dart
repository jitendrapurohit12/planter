import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gmt_planter/controllers/fund_history_notifier.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/helper/platform_widgets.dart';
import 'package:gmt_planter/helper/ui_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/ui/common_widget/bullet_row.dart';
import 'package:intl/intl.dart';
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
            case NotifierState.fetchingMore:
              return const _FundList();
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

class _FundList extends HookWidget {
  const _FundList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<FundHistoryNotifier>(context);
    final controller = useScrollController();

    controller.addListener(() {
      if (controller.position.atEdge) {
        if (controller.position.pixels != 0) {
          notifier.fetchMore(context);
        }
      }
    });

    return Consumer<FundHistoryNotifier>(
      builder: (context, value, child) {
        final list = value.items;
        return RefreshIndicator(
          onRefresh: () => notifier.resfresh(context),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            separatorBuilder: (context, index) => VxBox().gray200.make().wFull(context).h(1),
            controller: controller,
            itemCount: list.length + 1,
            itemBuilder: (context, index) {
              if (index == list.length) {
                if (value.allFetched) {
                  return 'All data fetched'.text.blue400.bold.xl.makeCentered().py12();
                } else {
                  return 'Fetching more...'.text.green400.bold.xl.makeCentered().py12();
                }
              }

              final model = list[index];
              final createdAt = DateFormat().format(DateTime.parse(model.createdAt));
              final subtitle = VStack([
                '\$${model.amountPaid}'.text.xl.bold.make(),
                createdAt.text.make(),
              ]);

              return Theme(
                data: ThemeData(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  title: model.projectName.text.xl.make(),
                  leading: CircleAvatar(
                    backgroundColor: getStatusColor(model.status),
                    child: Icon(getStatusIcon(model.status), color: Colors.white),
                  ),
                  subtitle: subtitle.py4(),
                  children: [
                    BulletRow('Partner Name', model.partnerName),
                    BulletRow('Planter User', model.planterUser),
                    BulletRow('Remark', model.remark),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
