import 'package:flutter/material.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/models/failure.dart';
import 'package:gmt_planter/models/translation_model.dart';
import 'package:gmt_planter/prefs/shared_prefs.dart';
import 'package:gmt_planter/service/api_service.dart';
import 'package:provider/provider.dart';

class CaptionController extends ChangeNotifier {
  Failure _error;
  CaptionModel _model;
  String _languageCode;
  Map<String, int> _captions = {};
  NotifierState _state = NotifierState.initial;

  Failure get error => _error;
  CaptionModel get model => _model;
  NotifierState get state => _state;
  String get languageCode => _languageCode;
  Map<String, int> get captions => _captions;

  Future reset() async {
    _error = null;
    _model = null;
    _captions = {};
    _state = NotifierState.initial;
    await zeroDelay();
    notifyListeners();
  }

  Future fetchCaptions(BuildContext context) async {
    await zeroDelay();
    _state = NotifierState.fetching;
    notifyListeners();

    Provider.of<ApiService>(context, listen: false).getCaptions().then((value) async {
      _model = value;
      await initCaptions();
      _state = NotifierState.loaded;
      notifyListeners();
    }).catchError((e) {
      _error = e as Failure;
      _state = NotifierState.error;
      notifyListeners();
    });
  }

  Future initCaptions() async {
    final languageCode = await getLanguageCode();
    _captions.clear();
    if (model == null) return;
    for (final caption in model.data) {
      switch (languageCode) {
        case kLangIn:
          if (caption.bahasaIndonesia?.isNotEmpty ?? false) {
            _captions[caption.bahasaIndonesia] = caption.id;
          } else {
            _captions[caption.name] = caption.id;
          }
          break;
        default:
          _captions[caption.name] = caption.id;
          break;
      }
    }
    notifyListeners();
  }
}
