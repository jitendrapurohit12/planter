import 'package:flutter/material.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/models/auth_model.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/models/failure.dart';
import 'package:gmt_planter/service/api_service.dart';
import 'package:provider/provider.dart';

class LoginController extends ChangeNotifier {
  AuthModel _model;
  Failure _error;
  NotifierState _state = NotifierState.initial;
  bool _showPassword = false;

  AuthModel get model => _model;
  Failure get error => _error;
  NotifierState get state => _state;
  bool get showPassowrd => _showPassword;

  Future<void> reset() async {
    _model = null;
    _error = null;
    await zeroDelay();
    notifyListeners();
  }

  Future<void> changeVisibility() async {
    _showPassword = !_showPassword;
    await zeroDelay();
    notifyListeners();
  }

  Future<void> login({
    @required BuildContext context,
    @required String email,
    @required String password,
  }) async {
    assert(context != null);
    assert(email != null);
    assert(password != null);

    await zeroDelay();
    _state = NotifierState.fetching;
    notifyListeners();

    Provider.of<ApiService>(context, listen: false)
        .login(email: email, password: password)
        .then((value) {
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
