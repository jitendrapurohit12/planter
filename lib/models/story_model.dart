class StoryModel {
  int uId;
  int pId;
  String pic;
  String stName;
  String caption;

  StoryModel({this.uId, this.pId, this.pic, this.stName, this.caption});

  StoryModel.fromJson(Map<String, dynamic> json) {
    uId = json['u_id'] as int;
    pId = json['p_id'] as int;
    pic = json['pic'] as String;
    stName = json['st_name'] as String;
    caption = json['caption'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['u_id'] = uId;
    data['p_id'] = pId;
    data['st_name'] = stName;
    data['caption'] = caption;
    return data;
  }
}
