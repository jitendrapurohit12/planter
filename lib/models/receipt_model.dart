class ReceiptModel {
  int amount, projectId, fundId;
  String pic;

  ReceiptModel({this.amount, this.projectId, this.fundId, this.pic});

  ReceiptModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'] as int;
    projectId = json['project_id'] as int;
    fundId = json['fund_id'] as int;
    pic = json['pic'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['amount'] = amount;
    data['project_id'] = projectId;
    data['fund_id'] = fundId;
    data['pic'] = pic;
    return data;
  }
}
