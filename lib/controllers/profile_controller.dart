import 'dart:io';

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
  File _file;
  NotifierState _state = NotifierState.initial;

  UserProfileModel get model => _model;
  Failure get error => _error;
  NotifierState get state => _state;
  bool get isEditing => _isEditMode;
  File get file => _file;

  Future<void> setIsEditing({bool value = false}) async {
    _isEditMode = value;
    await zeroDelay();
    notifyListeners();
  }

  Future<void> changeImage(File file) async {
    _file = file;
    await zeroDelay();
    notifyListeners();
  }

  Future<bool> updateInfo({@required BuildContext context}) async {
    assert(context != null);

    bool success = false;

    await zeroDelay();
    _state = NotifierState.fetching;
    notifyListeners();

    await Provider.of<ApiService>(context, listen: false)
        .setUserProfile(profile: model, file: _file)
        .then((value) {
      setIsEditing();
      _model = value;
      _file = null;
      _state = NotifierState.loaded;
      success = true;
      notifyListeners();
    }).catchError((e) {
      _error = e as Failure;
      _state = NotifierState.error;
      notifyListeners();
    });

    return success;
  }

  Future<void> getInfo({@required BuildContext context}) async {
    assert(context != null);

    await zeroDelay();
    _state = NotifierState.fetching;
    notifyListeners();

    Provider.of<ApiService>(context, listen: false).getUserProfile().then((value) {
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
