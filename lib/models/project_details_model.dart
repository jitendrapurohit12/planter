class ProjectDetailsModel {
  bool success;
  String message;
  Data data;

  ProjectDetailsModel({this.data, this.message, this.success});

  ProjectDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] as bool;
    message = json['message'] as String;
    data = json['data'] != null ? Data.fromJson(json['data'] as Map<String, dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String name, thumbnailUrl, community;
  num totalNoOfTrees, id, femaleEmpTarget, plantingBalance, plantingDensity;
  num conservationBalance, fundsRaised, plantationSize, totalFundingTarget;

  Data(
      {this.id,
      this.name,
      this.thumbnailUrl,
      this.plantationSize,
      this.plantingDensity,
      this.totalNoOfTrees,
      this.community,
      this.femaleEmpTarget,
      this.plantingBalance,
      this.conservationBalance,
      this.fundsRaised,
      this.totalFundingTarget});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    name = json['name'] as String;
    thumbnailUrl = json['thumbnail_url'] as String;
    plantationSize = json['plantation_size'] as num;
    plantingDensity = json['planting_density'] as num;
    totalNoOfTrees = json['total_no_of_trees'] as num;
    community = json['community'] as String;
    femaleEmpTarget = json['female_emp_target'] as num;
    plantingBalance = json['planting_balance'] as num;
    conservationBalance = json['conservation_balance'] as num;
    fundsRaised = json['funds_raised'] as num;
    totalFundingTarget = json['total_funding_target'] as num;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['thumbnail_url'] = thumbnailUrl;
    data['plantation_size'] = plantationSize;
    data['planting_density'] = plantingDensity;
    data['total_no_of_trees'] = totalNoOfTrees;
    data['community'] = community;
    data['female_emp_target'] = femaleEmpTarget;
    data['planting_balance'] = plantingBalance;
    data['conservation_balance'] = conservationBalance;
    data['funds_raised'] = fundsRaised;
    data['total_funding_target'] = totalFundingTarget;
    return data;
  }
}
