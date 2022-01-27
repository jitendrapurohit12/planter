class FundHistoryModel {
  List<Items> items;
  Pagination pagination;

  FundHistoryModel({this.items, this.pagination});

  FundHistoryModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items.add(Items.fromJson(v as Map<String, dynamic>));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
        : null;
  }
}

class Items {
  int id;
  String partnerName;
  String projectName;
  String planterUser;
  String amountPaid;
  String status;
  String remark;
  String pic;
  String createdAt;

  Items(
      {this.id,
      this.partnerName,
      this.projectName,
      this.planterUser,
      this.amountPaid,
      this.status,
      this.remark,
      this.pic,
      this.createdAt});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    partnerName = json['partner_name'] as String;
    projectName = json['project_name'] as String;
    planterUser = json['planter_user'] as String;
    amountPaid = json['amount_paid'] as String;
    status = json['status'] as String;
    remark = json['remark'] as String;
    pic = json['pic'] as String;
    createdAt = json['created_at'] as String;
  }
}

class Pagination {
  int count;
  int currentPage;
  int lastPage;
  int total;

  Pagination({this.count, this.currentPage, this.lastPage, this.total});

  Pagination.fromJson(Map<String, dynamic> json) {
    count = json['count'] as int;
    currentPage = json['currentPage'] as int;
    lastPage = json['lastPage'] as int;
    total = json['total'] as int;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['currentPage'] = currentPage;
    data['lastPage'] = lastPage;
    data['total'] = total;
    return data;
  }
}
