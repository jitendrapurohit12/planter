class VersionModel {
  bool success;
  String message;
  List<Data> data;

  VersionModel({this.success, this.message, this.data});

  VersionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] as bool;
    message = json['message'] as String;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(Data.fromJson(v as Map<String, dynamic>));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int id, version;
  String isMandatory, createdAt, updatedAt;

  Data({this.id, this.version, this.isMandatory, this.createdAt, this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    version = json['version'] as int;
    isMandatory = json['is_mandatory'] as String;
    createdAt = json['created_at'] as String;
    updatedAt = json['updated_at'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['version'] = version;
    data['is_mandatory'] = isMandatory;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
