import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/models/failure.dart';
import 'package:gmt_planter/models/pagination.dart';
import 'package:gmt_planter/models/project_story_list_model.dart';
import 'package:gmt_planter/service/api_service.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class ProjectStroyListNotifier extends ChangeNotifier {
  Failure error;
  int pageNo = 0;
  Pagination pagination;
  List<Story> items = [];
  bool allFetched = false, canFetch = true;
  NotifierState state = NotifierState.initial;

  Future reset() async {
    pageNo = 0;
    error = null;
    items.clear();
    canFetch = true;
    pagination = null;
    allFetched = false;
    state = NotifierState.initial;
  }

  Future resfresh(BuildContext context) async {
    await reset();
    await fetchProjectStories(context, changeState: false);
  }

  Future fetchMore(BuildContext context) async {
    if (!allFetched && state != NotifierState.fetchingMore && canFetch) {
      canFetch = false;
      final nextPage = pageNo + 1;
      fetchProjectStories(
        context,
        page: nextPage,
        changedState: NotifierState.fetchingMore,
      );

      Timer(1.seconds, () => canFetch = true);
    }
  }

  Future fetchProjectStories(
    BuildContext context, {
    int page = 1,
    bool changeState = true,
    NotifierState changedState = NotifierState.fetching,
  }) async {
    await zeroDelay();
    if (changeState) {
      state = changedState;
      notifyListeners();
    }

    try {
      final model =
          await Provider.of<ApiService>(context, listen: false).getProjectStories(page: page);
      allFetched = model.pagination.currentPage == model.pagination.lastPage;
      pagination = model.pagination;
      pageNo++;
      items.addAll(model.items);
      if (items.isNotEmpty) {
        state = NotifierState.loaded;
        notifyListeners();
      } else {
        state = NotifierState.noData;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      error = e as Failure;
      state = NotifierState.error;
      notifyListeners();
    }
  }
}
