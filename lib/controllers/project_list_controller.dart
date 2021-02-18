import 'package:flutter/material.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/models/failure.dart';
import 'package:gmt_planter/models/project_list_model.dart';
import 'package:gmt_planter/service/api_service.dart';
import 'package:provider/provider.dart';

class ProjectListController extends ChangeNotifier {
  ProjectListModel _model;
  Failure _error;
  NotifierState _state = NotifierState.initial;

  ProjectListModel get model => _model;
  Failure get error => _error;
  NotifierState get state => _state;

  Future<void> getProjects({@required BuildContext context}) async {
    _state = NotifierState.fetching;
    await zeroDelay();
    notifyListeners();

    Provider.of<ApiService>(context, listen: false).getProjects().then((value) {
      _model = value;
      final noActiveFunding = value?.data?.activeFundingProjects?.isEmpty ?? true;
      final noActiveManagement = value?.data?.activeManagementProjects?.isEmpty ?? true;
      final noActiveDeployed = value?.data?.notDeployedProjects?.isEmpty ?? true;
      if (noActiveFunding && noActiveManagement && noActiveDeployed) {
        _state = NotifierState.noData;
        notifyListeners();
        return;
      }
      _state = NotifierState.loaded;
      notifyListeners();
    }).catchError((e) {
      _error = e as Failure;
      _state = NotifierState.error;
      notifyListeners();
    });
  }
}
