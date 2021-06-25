import 'package:flutter/material.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/models/failure.dart';
import 'package:gmt_planter/models/project_details_model.dart';
import 'package:gmt_planter/service/api_service.dart';
import 'package:provider/provider.dart';

class ProjectDetailController extends ChangeNotifier {
  ProjectDetailsModel _model;
  Failure _error;
  NotifierState _state = NotifierState.initial;

  ProjectDetailsModel get model => _model;
  Failure get error => _error;
  NotifierState get state => _state;

  void reset() {
    _model = null;
    _error = null;
    _state = NotifierState.initial;
  }

  Future<void> getProjectDetails({
    @required BuildContext context,
    @required int id,
  }) async {
    assert(context != null);
    assert(id != null);

    await zeroDelay();
    _state = NotifierState.fetching;
    notifyListeners();

    Provider.of<ApiService>(context, listen: false)
        .getProjectDetails(id: id)
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
