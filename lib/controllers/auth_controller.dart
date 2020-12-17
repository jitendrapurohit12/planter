import 'package:flutter/material.dart';
import 'package:gmt_planter/models/auth_model.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/models/failure.dart';
import 'package:gmt_planter/service/api_service.dart';
import 'package:provider/provider.dart';

class AuthController extends ChangeNotifier {
  AuthModel _model;
  Failure _error;
  NotifierState _state = NotifierState.initial;

  AuthModel get model => _model;
  Failure get error => _error;
  NotifierState get state => _state;

  Future<void> login({
    @required BuildContext context,
    @required String email,
    @required String password,
  }) async {
    assert(context != null);
    assert(email != null);
    assert(password != null);

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
