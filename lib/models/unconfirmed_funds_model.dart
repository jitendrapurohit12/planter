class UnconfirmedFundsModel {
  bool success;
  String message;
  List<Data> data;

  UnconfirmedFundsModel({this.success, this.message, this.data});

  UnconfirmedFundsModel.fromJson(Map<String, dynamic> json) {
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
  int id, amount, projectId;
  String pic, createdAt;
  Project project;

  Data({this.id, this.amount, this.pic, this.createdAt, this.projectId, this.project});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    amount = json['amount'] as int;
    pic = json['pic'] as String;
    createdAt = json['created_at'] as String;
    projectId = json['project_id'] as int;
    project =
        json['project'] != null ? Project.fromJson(json['project'] as Map<String, dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['pic'] = pic;
    data['created_at'] = createdAt;
    data['project_id'] = projectId;
    if (project != null) {
      data['project'] = project.toJson();
    }
    return data;
  }
}

class Project {
  int id;
  String name, thumbnailUrl;

  Project({this.id, this.name, this.thumbnailUrl});

  Project.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    name = json['name'] as String;
    thumbnailUrl = json['thumbnail_url'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['thumbnail_url'] = thumbnailUrl;
    return data;
  }
}
