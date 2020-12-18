import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gmt_planter/models/auth_model.dart';
import 'package:gmt_planter/models/failure.dart';
import 'package:gmt_planter/models/project_details_model.dart';
import 'package:gmt_planter/models/project_list_model.dart';
import 'package:gmt_planter/models/story_caption_model.dart';
import 'package:gmt_planter/models/story_model.dart';
import 'package:gmt_planter/models/user_profile_model.dart';
import 'package:gmt_planter/prefs/shared_prefs.dart';

const kLoginBaseUrl = 'https://grovedev-auth.cfapps.io';
const kBaseUrl = 'https://grovedev-admin-ui-backend.cfapps.io';

const kLoginUrl = '/api/tf/user/login';
const kProjectList = '/v1/planter-project-list';
const kProjectDetails = '/v1/planter-project-details';
const kUserProfile = '/v1/planter-user';
const kGetUnconfirmedFunds = '/v1/planter-logFunds-send';
const kStoryCaptions = '/v1/planter-captions';
const kUploadFile = '/v1/file';
const kUploadPlanterStory = '/v1/planter-story';
const kUploadRecipt = '/v1/planter-logFunds-arrive';

final loginHeader = {
  'X-Requested-With': 'XMLHttpRequest',
  'Content-Type': 'application/json',
};

final uploadImageHeader = {
  'Content-Type': 'application/octet-stream',
  'Accept-Encoding': 'gzip,deflate',
  'Accept': 'multipart/form-data'
};

Future<Map<String, dynamic>> getAuthApiHeader() async {
  final token = await getToken();
  final map = {
    'Content-Type': 'application/json;charset=utf-8',
    'Accept-Encoding': 'gzip,deflate',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
  return map;
}

class ApiService {
  final _dio = Dio();

  Future<AuthModel> login({
    @required String email,
    @required String password,
  }) async {
    assert(email != null);
    assert(password != null);

    final map = {
      'email': email,
      'password': password,
    };

    final res = await _dio
        .post('$kLoginBaseUrl$kLoginUrl',
            options: Options(headers: loginHeader), data: map)
        .catchError((e) => throw getFailure(e));
    return AuthModel.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  Future<ProjectListModel> getProjects() async {
    final headers = await getAuthApiHeader();

    final res = await _dio
        .get('$kBaseUrl$kProjectList', options: Options(headers: headers))
        .catchError((e) => throw getFailure(e));
    final model = ProjectListModel.fromJson(res.data as Map<String, dynamic>);
    return model;
  }

  Future<ProjectDetailsModel> getProjectDetails({@required int id}) async {
    final headers = await getAuthApiHeader();

    final res = await _dio
        .get('$kBaseUrl$kProjectDetails/$id',
            options: Options(headers: headers))
        .catchError((e) => throw getFailure(e));
    final model =
        ProjectDetailsModel.fromJson(res.data as Map<String, dynamic>);
    return model;
  }

  Future<StoryCaptionModel> getStoryCaptions() async {
    final headers = await getAuthApiHeader();

    final res = await _dio
        .get('$kBaseUrl$kStoryCaptions', options: Options(headers: headers))
        .catchError((e) => throw getFailure(e));
    final model = StoryCaptionModel.fromJson(res.data as Map<String, dynamic>);
    return model;
  }

  Future<UserProfileModel> getUserProfile() async {
    final headers = await getAuthApiHeader();

    final res = await _dio
        .get('$kBaseUrl$kUserProfile', options: Options(headers: headers))
        .catchError((e) => throw getFailure(e));
    final model = UserProfileModel.fromJson(res.data as Map<String, dynamic>);
    return model;
  }

  Future<UserProfileModel> setUserProfile({
    @required UserProfileModel profile,
  }) async {
    assert(profile != null);
    final headers = await getAuthApiHeader();

    final res = await _dio
        .put(
          '$kBaseUrl$kUserProfile',
          options: Options(headers: headers),
          data: profile.toJson(),
        )
        .catchError((e) => throw getFailure(e));
    final model = UserProfileModel.fromJson(res.data as Map<String, dynamic>);
    return model;
  }

  Future<void> uploadProjectStory({@required StoryModel model}) async {
    assert(model != null);
    final headers = await getAuthApiHeader();

    await _dio
        .post(
          '$kBaseUrl$kUploadPlanterStory',
          options: Options(headers: headers),
          data: model.toJson(),
        )
        .catchError((e) => throw getFailure(e));
  }

  Future<void> uploadImage({@required String path}) async {
    assert(path != null);

    // await _dio
    //     .post(
    //       '$kBaseUrl$kUploadFile',
    //       options: Options(headers: uploadImageHeader),
    //       data: model.toJson(),
    //     )
    //     .catchError((e) => throw getFailure(e));
  }

  Failure getFailure(dynamic error) {
    if (error is DioError) {
      final dioError = error;
      return Failure(
        code: 404,
        message: dioError.response.data['message'].toString(),
      );
    } else {
      return Failure(
        code: 404,
        message: 'Something went wrong!',
      );
    }
  }
}
