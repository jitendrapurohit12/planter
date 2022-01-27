import 'package:flutter/material.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/models/failure.dart';
import 'package:gmt_planter/models/fund_history_model.dart';
import 'package:gmt_planter/service/api_service.dart';
import 'package:provider/provider.dart';

class FundHistoryNotifier extends ChangeNotifier {
  Failure error;
  FundHistoryModel model;
  NotifierState state = NotifierState.initial;

  Future fetchFundHIstory(BuildContext context) async {
    await zeroDelay();
    state = NotifierState.fetching;
    notifyListeners();
    try {
      model = await Provider.of<ApiService>(context, listen: false).getFundHistory();
      if (model.items.isNotEmpty) {
        state = NotifierState.loaded;
        notifyListeners();
      } else {
        state = NotifierState.noData;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      error = e as Failure;
      state = NotifierState.error;
      notifyListeners();
    }
  }
}
