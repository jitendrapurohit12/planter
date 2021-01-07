import 'dart:io';

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

const kBaseUrl = 'https://staging.handprint.tech/api/';

const kLoginUrl = 'planter-login';
const kProjectList = 'project-list';
const kProjectDetails = 'project-detail';
const kUserProfile = 'user-profile';
const kUpdateUserProfile = 'update-user-profile';
const kGetUnconfirmedFunds = 'v1/planter-logFunds-send';
const kStoryCaptions = 'project-story-caption';
const kUploadFile = 'v1/file';
const kUploadPlanterStory = 'v1/planter-story';
const kUploadRecipt = 'v1/planter-logFunds-arrive';

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
    'Accept-Encoding': 'gzip,deflate,br',
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
        .post('$kBaseUrl$kLoginUrl',
            options: Options(headers: loginHeader), data: map)
        .catchError((e) => throw getFailure(e));
    return AuthModel.fromJson(res.data as Map<String, dynamic>);
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

    final data = {'project_id': id};

    final res = await _dio
        .post('$kBaseUrl$kProjectDetails',
            options: Options(headers: headers), data: data)
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
    File file,
  }) async {
    assert(profile != null);
    final headers = await getAuthApiHeader();

    final formData = FormData.fromMap(profile.data.toJson());

    if (file != null) {
      final multipart = MapEntry(
        'pic',
        MultipartFile.fromFileSync(file.path,
            filename: 'profile${profile.data.id}'),
      );

      formData.files.add(multipart);
    }

    final res = await _dio
        .post(
          '$kBaseUrl$kUpdateUserProfile',
          options: Options(headers: headers),
          data: formData,
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
