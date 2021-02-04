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
  bool _isListShown = false;
  Failure _error;
  NotifierState _state = NotifierState.initial;

  UnconfirmedFundsModel get model => _model;
  int get selectedpage => _selectedPage;
  bool get isListShown => _isListShown;
  Failure get error => _error;
  NotifierState get state => _state;

  Future<void> changeListShown({bool value = false}) async {
    _isListShown = value;
    await refresh();
  }

  Future<void> refresh() async {
    await zeroDelay();
    notifyListeners();
  }

  Future<void> changePage(int newPage) async {
    _selectedPage = newPage;
    await refresh();
  }

  Future<void> removeItem(int index) async {
    model.data.removeAt(index);
    refresh();
  }

  Future<void> getUnconfirmedFunds({@required BuildContext context}) async {
    _state = NotifierState.fetching;
    await refresh();

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
