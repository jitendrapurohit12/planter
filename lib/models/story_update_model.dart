class StoryUpdateModel {
  int uId, caption, sId;

  StoryUpdateModel({this.uId, this.caption});

  StoryUpdateModel.fromJson(Map<String, dynamic> json) {
    uId = json['u_id'] as int;
    sId = json['s_id'] as int;
    caption = json['caption'] as int;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['u_id'] = uId;
    data['s_id'] = sId;
    data['caption'] = caption;
    return data;
  }
}
