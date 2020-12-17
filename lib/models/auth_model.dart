class AuthModel {
  String token;
  String name;
  String refreshToken;

  AuthModel({this.token, this.name, this.refreshToken});

  AuthModel.fromJson(Map<String, dynamic> json) {
    token = json['token'] as String;
    name = json['name'] as String;
    refreshToken = json['refresh_token'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['name'] = name;
    data['refresh_token'] = refreshToken;
    return data;
  }
}
