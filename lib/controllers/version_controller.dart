import 'package:flutter/material.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/models/failure.dart';
import 'package:gmt_planter/models/version_model.dart';
import 'package:gmt_planter/service/api_service.dart';
import 'package:provider/provider.dart';

class VersionControler extends ChangeNotifier {
  Failure _error;
  VersionModel _model;
  NotifierState _state = NotifierState.initial;

  VersionModel get model => _model;
  Failure get error => _error;
  NotifierState get state => _state;

  Future<void> reset() async {
    _model = null;
    _error = null;
    await zeroDelay();
    notifyListeners();
    _state = NotifierState.initial;
  }

  Future getVersions(BuildContext context) async {
    await zeroDelay();
    _state = NotifierState.fetching;
    notifyListeners();

    Provider.of<ApiService>(context, listen: false).getVersions().then((value) {
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
