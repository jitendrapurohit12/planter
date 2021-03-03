import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gmt_planter/models/auth_model.dart';
import 'package:gmt_planter/models/failure.dart';
import 'package:gmt_planter/models/project_details_model.dart';
import 'package:gmt_planter/models/project_list_model.dart';
import 'package:gmt_planter/models/receipt_model.dart';
import 'package:gmt_planter/models/story_model.dart';
import 'package:gmt_planter/models/unconfirmed_funds_model.dart';
import 'package:gmt_planter/models/user_profile_model.dart';
import 'package:gmt_planter/prefs/shared_prefs.dart';

const kBaseUrl = 'https://dashboard.handprint.tech/pltr/api/v1/';
//const kBaseUrl = 'https://staging.handprint.tech/pltr/api/v1/';

const kLoginUrl = 'planter-login';
const kProjectList = 'project-list';
const kProjectDetails = 'project-detail';
const kUserProfile = 'user-profile';
const kUpdateUserProfile = 'update-user-profile';
const kGetUnconfirmedFunds = 'project-unconfirmed-fund';
const kStoryCaptions = 'project-story-caption';
const kUploadPlanterStory = 'project-story-save';
const kUploadRecipt = 'project-fund-update';
const kLogout = 'user-logout';

final loginHeader = {
  'X-Requested-With': 'XMLHttpRequest',
  'Content-Type': 'application/json',
};

Future<Map<String, dynamic>> getAuthApiHeader() async {
  final token = await getToken();
  final map = {
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
        .post('$kBaseUrl$kLoginUrl', options: Options(headers: loginHeader), data: map)
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
        .post('$kBaseUrl$kProjectDetails', options: Options(headers: headers), data: data)
        .catchError((e) => throw getFailure(e));
    final model = ProjectDetailsModel.fromJson(res.data as Map<String, dynamic>);
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

    final data = profile.data.toJson();

    if (file != null) {
      final time = DateTime.now().second;
      data['pic'] = MultipartFile.fromFileSync(file.path, filename: 'profile_image_$time');
    }

    final formData = FormData.fromMap(data);

    final res = await _dio
        .post(
          '$kBaseUrl$kUpdateUserProfile',
          options: Options(
            headers: headers,
            contentType: Headers.formUrlEncodedContentType,
          ),
          data: formData,
        )
        .catchError((e) => throw getFailure(e));

    final model = UserProfileModel.fromJson(res.data as Map<String, dynamic>);
    return model;
  }

  Future<void> uploadProjectStory({
    @required StoryModel model,
    @required File file,
  }) async {
    assert(model != null);
    final headers = await getAuthApiHeader();

    final data = model.toJson();

    if (file != null) {
      data['pic'] = MultipartFile.fromFileSync(
        file.path,
        filename: 'project_story_${model.caption}',
      );
    }

    final formData = FormData.fromMap(data);

    await _dio
        .post(
          '$kBaseUrl$kUploadPlanterStory',
          options: Options(
            headers: headers,
            contentType: Headers.formUrlEncodedContentType,
          ),
          data: formData,
        )
        .catchError((e) => throw getFailure(e));
  }

  Future<UnconfirmedFundsModel> getUnconfirmedFunds() async {
    final headers = await getAuthApiHeader();

    final res = await _dio
        .get('$kBaseUrl$kGetUnconfirmedFunds', options: Options(headers: headers))
        .catchError((e) => throw getFailure(e));
    final model = UnconfirmedFundsModel.fromJson(res.data as Map<String, dynamic>);
    return model;
  }

  Future<void> postReceipt({
    @required ReceiptModel receipt,
    @required File file,
  }) async {
    final headers = await getAuthApiHeader();

    final data = receipt.toJson();

    if (file != null) {
      final time = DateTime.now().second;
      data['pic'] = MultipartFile.fromFileSync(
        file.path,
        filename: 'receipt_$time',
      );
    }

    final formData = FormData.fromMap(data);

    await _dio
        .post(
          '$kBaseUrl$kUploadRecipt',
          options: Options(
            headers: headers,
            contentType: Headers.formUrlEncodedContentType,
          ),
          data: formData,
        )
        .catchError((e) => throw getFailure(e));
  }

  Future<bool> logout() async {
    final headers = await getAuthApiHeader();

    await _dio
        .get('$kBaseUrl$kLogout', options: Options(headers: headers))
        .catchError((e) => throw getFailure(e));
    return true;
  }

  Failure getFailure(dynamic error) {
    if (error is DioError) {
      final dioError = error;
      String message;
      try {
        message = dioError?.response?.data['message'].toString();
      } catch (e) {
        message = dioError.message ?? 'Something went wrong!';
      }
      final code = dioError?.response?.statusCode ?? 404;
      return Failure(
        code: code,
        message: message,
      );
    } else {
      return Failure(
        code: 404,
        message: 'Something went wrong!',
      );
    }
  }
}
