class TranslationModel {
  List<Captions> captions;

  TranslationModel({this.captions});

  TranslationModel.fromJson(Map<String, dynamic> json) {
    if (json['captions'] != null) {
      captions = <Captions>[];
      json['captions'].forEach((v) {
        captions.add(Captions.fromJson(v as Map<String, dynamic>));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (captions != null) {
      data['captions'] = captions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Captions {
  int id;
  String name;

  Captions({this.id, this.name});

  Captions.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    name = json['name'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
