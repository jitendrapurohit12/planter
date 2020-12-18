class UploadImageModel {
  List<ImageDetailModel> data;

  UploadImageModel({this.data});

  UploadImageModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ImageDetailModel>[];
      json['data'].forEach((v) {
        data.add(ImageDetailModel.fromJson(v as Map<String, dynamic>));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImageDetailModel {
  String uploadUrl, imageUrl;

  ImageDetailModel({this.uploadUrl, this.imageUrl});

  ImageDetailModel.fromJson(Map<String, dynamic> json) {
    uploadUrl = json['upload_url'] as String;
    imageUrl = json['image_url'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['upload_url'] = uploadUrl;
    data['image_url'] = imageUrl;
    return data;
  }
}
