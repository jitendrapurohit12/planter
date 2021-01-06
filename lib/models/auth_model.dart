class AuthModel {
  bool success;
  String message;
  Data data;

  AuthModel({this.success, this.message, this.data});

  AuthModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] as bool;
    message = json['message'] as String;
    data = json['data'] != null
        ? Data.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int id, status;
  String name, firstName, lastName, timestamp, token;

  Data(
      {this.id,
      this.name,
      this.firstName,
      this.lastName,
      this.status,
      this.timestamp,
      this.token});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    status = json['status'] as int;
    name = json['name'] as String;
    firstName = json['first_name'] as String;
    lastName = json['last_name'] as String;
    timestamp = json['timestamp'] as String;
    token = json['token'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['status'] = status;
    data['timestamp'] = timestamp;
    data['token'] = token;
    return data;
  }
}
