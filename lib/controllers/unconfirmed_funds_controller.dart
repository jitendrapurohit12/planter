import 'package:flutter/material.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/models/failure.dart';
import 'package:gmt_planter/models/unconfirmed_funds_model.dart';
import 'package:gmt_planter/service/api_service.dart';
import 'package:provider/provider.dart';

class UnconfirmedFundsController extends ChangeNotifier {
  UnconfirmedFundsModel _model;
  int _selectedPage = 0;
  Failure _error;
  NotifierState _state = NotifierState.initial;

  UnconfirmedFundsModel get model => _model;
  int get selectedpage => _selectedPage;
  Failure get error => _error;
  NotifierState get state => _state;

  Future<void> changepage(int newPage) async {
    _selectedPage = newPage;
    await zeroDelay();
    notifyListeners();
  }

  Future<void> getUnconfirmedFunds({@required BuildContext context}) async {
    _state = NotifierState.fetching;
    await zeroDelay();
    notifyListeners();

    Provider.of<ApiService>(context, listen: false).getUnconfirmedFunds().then((value) {
      _model = value;
      _state = NotifierState.loaded;
      notifyListeners();
    }).catchError((e) {
      _error = e as Failure;
      _state = NotifierState.error;
      notifyListeners();
    });
  }
}
