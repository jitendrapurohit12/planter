import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/models/failure.dart';
import 'package:gmt_planter/models/fund_history_model.dart';
import 'package:gmt_planter/models/project_list_model.dart';
import 'package:gmt_planter/service/api_service.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/src/extensions/num_ext.dart';

class ProjectListController extends ChangeNotifier {
  Failure _error;
  int pageNo = 0;
  Pagination _pagination;
  List<ProjectModel> list = [];
  bool allFetched = false, canFetch = true;
  NotifierState _state = NotifierState.initial;

  Failure get error => _error;
  NotifierState get state => _state;

  Future<void> reset() async {
    pageNo = 0;
    list.clear();
    _error = null;
    canFetch = true;
    _pagination = null;
    allFetched = false;
    _state = NotifierState.initial;
  }

  Future refresh(BuildContext context) async {
    await reset();
    await getProjects(context, changeState: false);
  }

  Future fetchMore(BuildContext context) async {
    if (!allFetched && state != NotifierState.fetchingMore && canFetch) {
      canFetch = false;
      final nextPage = pageNo + 1;
      getProjects(
        context,
        page: nextPage,
        changedState: NotifierState.fetchingMore,
      );

      Timer(1.seconds, () => canFetch = true);
    }
  }

  Future<void> getProjects(
    BuildContext context, {
    int page = 1,
    bool changeState = true,
    NotifierState changedState = NotifierState.fetching,
  }) async {
    await zeroDelay();
    if (changeState) {
      _state = changedState;
      notifyListeners();
    }

    await Provider.of<ApiService>(context, listen: false).getProjects().then((value) {
      allFetched = value.pagination.currentPage == value.pagination.lastPage;
      _pagination = value.pagination;
      pageNo++;
      list.addAll(value.activeFundingProjects);
      if (list.isNotEmpty) {
        _state = NotifierState.loaded;
        notifyListeners();
      } else {
        _state = NotifierState.noData;
        notifyListeners();
      }
    }).catchError((e) {
      _error = e as Failure;
      _state = NotifierState.error;
      notifyListeners();
    });
  }
}
