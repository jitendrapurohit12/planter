import 'package:flutter/material.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/models/story_model.dart';

class StoryLocalController extends ChangeNotifier {
  StoryModel _model;

  StoryModel get model => _model;

  Future<void> refresh() async {
    await zeroDelay();
    notifyListeners();
  }
}
