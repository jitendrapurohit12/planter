import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gmt_planter/models/auth_model.dart';
import 'package:gmt_planter/models/failure.dart';
import 'package:gmt_planter/models/project_details_model.dart';
import 'package:gmt_planter/models/project_list_model.dart';
import 'package:gmt_planter/prefs/shared_prefs.dart';

const kLoginBaseUrl = 'https://grovedev-auth.cfapps.io';
const kBaseUrl = 'https://grovedev-admin-ui-backend.cfapps.io';

const kLoginUrl = '/api/tf/user/login';
const kProjectList = '/v1/planter-project-list';
const kProjectDetails = '/v1/planter-project-details';

final loginHeader = {
  'X-Requested-With': 'XMLHttpRequest',
  'Content-Type': 'application/json',
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
