class ReceiptModel {
  int projectId, fundId;
  String pic, status, remark;

  ReceiptModel({this.projectId, this.fundId, this.remark, this.pic});

  ReceiptModel.fromJson(Map<String, dynamic> json) {
    projectId = json['project_id'] as int;
    fundId = json['fund_id'] as int;
    status = json['status'] as String;
    remark = json['remark'] as String;
    pic = json['pic'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['project_id'] = projectId;
    data['fund_id'] = fundId;
    data['pic'] = pic;
    data['status'] = status;
    data['remark'] = remark;
    return data;
  }
}
