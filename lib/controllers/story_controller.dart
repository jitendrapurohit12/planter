import 'package:flutter/material.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/models/failure.dart';
import 'package:gmt_planter/models/story_model.dart';
import 'package:gmt_planter/service/api_service.dart';
import 'package:provider/provider.dart';

class StoryController extends ChangeNotifier {
  Failure _error;
  NotifierState _state = NotifierState.initial;

  Failure get error => _error;
  NotifierState get state => _state;

  Future<void> postStory({@required BuildContext context}) async {
    _state = NotifierState.fetching;
    notifyListeners();

    Provider.of<ApiService>(context, listen: false)
        .uploadProjectStory()
        .then((value) {
      _state = NotifierState.loaded;
      notifyListeners();
    }).catchError((e) {
      _error = e as Failure;
      _state = NotifierState.error;
      notifyListeners();
    });
  }
}
