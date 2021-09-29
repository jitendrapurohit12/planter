class CaptionModel {
  bool success;
  String message;
  List<Data> data;

  CaptionModel({this.success, this.message, this.data});

  CaptionModel.fromJson(Map<String, dynamic> json) {
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
  int id;
  String name;
  String bahasaIndonesia;

  Data({this.id, this.name, this.bahasaIndonesia});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    name = json['name'] as String;
    bahasaIndonesia = json['bahasa_indonesia'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['bahasa_indonesia'] = bahasaIndonesia;
    return data;
  }
}
