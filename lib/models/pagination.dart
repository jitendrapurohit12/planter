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
