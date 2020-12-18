class StoryCaptionModel {
  List<String> data;

  StoryCaptionModel({this.data});

  StoryCaptionModel.fromJson(Map<String, dynamic> json) {
    data = json['data']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['data'] = this.data;
    return data;
  }
}
