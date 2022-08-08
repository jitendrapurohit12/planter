import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/models/failure.dart';
import 'package:gmt_planter/models/story_update_model.dart';
import 'package:gmt_planter/service/api_service.dart';
import 'package:provider/provider.dart';

class StoryUpdateController extends ChangeNotifier {
  StoryUpdateModel _model = StoryUpdateModel();
  Failure _error;
  File _file;
  NotifierState _state = NotifierState.initial;

  StoryUpdateModel get model => _model;
  Failure get error => _error;
  NotifierState get state => _state;
  File get file => _file;

  Future<void> reset() async {
    _file = null;
    _model = StoryUpdateModel();
    _state = NotifierState.initial;
    refresh();
  }

  Future<void> refresh() async {
    await zeroDelay();
    notifyListeners();
  }

  Future<void> changeImage(File file) async {
    _file = file;
    refresh();
  }

  Future<void> postStory({@required BuildContext context}) async {
    _state = NotifierState.fetching;
    refresh();

    Provider.of<ApiService>(context, listen: false)
        .updateProjectStory(model: model, file: _file)
        .then((value) {
      _state = NotifierState.loaded;
      refresh();
    }).catchError((e) {
      _error = e as Failure;
      _state = NotifierState.error;
      refresh();
    });
  }
}
