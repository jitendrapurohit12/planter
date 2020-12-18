import 'package:flutter/material.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/models/failure.dart';
import 'package:gmt_planter/models/story_caption_model.dart';
import 'package:gmt_planter/service/api_service.dart';
import 'package:provider/provider.dart';

class StoryCaptionController extends ChangeNotifier {
  StoryCaptionModel _model;
  Failure _error;
  NotifierState _state = NotifierState.initial;

  StoryCaptionModel get model => _model;
  Failure get error => _error;
  NotifierState get state => _state;

  Future<void> getStoryCaptions({@required BuildContext context}) async {
    assert(context != null);

    await zeroDelay();
    _state = NotifierState.fetching;
    notifyListeners();

    Provider.of<ApiService>(context, listen: false)
        .getStoryCaptions()
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
