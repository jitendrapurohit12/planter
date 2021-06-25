class ImageUploadModel {
  List<Attributes> attributes;

  ImageUploadModel({this.attributes});

  ImageUploadModel.fromJson(Map<String, dynamic> json) {
    if (json['attributes'] != null) {
      attributes = <Attributes>[];
      json['attributes'].forEach((v) {
        attributes.add(Attributes.fromJson(v as Map<String, dynamic>));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (attributes != null) {
      data['attributes'] = attributes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attributes {
  String folder, fileType, fileExt, fileContentType;

  Attributes({this.folder, this.fileType, this.fileExt, this.fileContentType});

  Attributes.fromJson(Map<String, dynamic> json) {
    folder = json['folder'] as String;
    fileType = json['file_type'] as String;
    fileExt = json['file_ext'] as String;
    fileContentType = json['file_content_type'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['folder'] = folder;
    data['file_type'] = fileType;
    data['file_ext'] = fileExt;
    data['file_content_type'] = fileContentType;
    return data;
  }
}
