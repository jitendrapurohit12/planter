import 'package:flutter/material.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/models/failure.dart';
import 'package:gmt_planter/models/user_profile_model.dart';
import 'package:gmt_planter/service/api_service.dart';
import 'package:provider/provider.dart';

class ProfileController extends ChangeNotifier {
  UserProfileModel _model;
  bool _isEditMode = false;
  Failure _error;
  NotifierState _state = NotifierState.initial;

  UserProfileModel get model => _model;
  Failure get error => _error;
  NotifierState get state => _state;
  bool get isEditing => _isEditMode;

  Future<void> setIsEditing({bool value = false}) async {
    _isEditMode = value;
    await zeroDelay();
    notifyListeners();
  }

  Future<void> updateInfo({@required BuildContext context}) async {
    assert(context != null);

    await zeroDelay();
    _state = NotifierState.fetching;
    notifyListeners();

    Provider.of<ApiService>(context, listen: false)
        .setUserProfile(profile: model)
        .then((value) {
      setIsEditing(false);
      _state = NotifierState.loaded;
      notifyListeners();
    }).catchError((e) {
      _error = e as Failure;
      _state = NotifierState.error;
      notifyListeners();
    });
  }

  Future<void> getInfo({@required BuildContext context}) async {
    assert(context != null);

    await zeroDelay();
    _state = NotifierState.fetching;
    notifyListeners();

    Provider.of<ApiService>(context, listen: false)
        .getUserProfile()
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
