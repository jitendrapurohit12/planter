import 'package:gmt_planter/models/fund_history_model.dart';

class ProjectListModel {
  List<ProjectModel> activeFundingProjects;
  Pagination pagination;

  ProjectListModel({this.activeFundingProjects});

  ProjectListModel.fromJson(Map<String, dynamic> json) {
    if (json['ACTIVE_FUNDING'] != null) {
      activeFundingProjects = <ProjectModel>[];
      json['ACTIVE_FUNDING'].forEach((v) {
        activeFundingProjects.add(ProjectModel.fromJson(v as Map<String, dynamic>));
      });
    }
    pagination = Pagination.fromJson(json['pagination'] as Map<String, dynamic>);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (activeFundingProjects != null) {
      data['ACTIVE_FUNDING'] = activeFundingProjects.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProjectModel {
  int id;
  num boughtImpactQty, projectImpactQty;
  String name, thumbnailUrl, fundingStatus, projectCompletion;

  ProjectModel({this.id, this.name, this.thumbnailUrl, this.fundingStatus});

  ProjectModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    name = json['name'] as String;
    thumbnailUrl = json['thumbnail_url'] as String;
    fundingStatus = json['funding_status'] as String;
    boughtImpactQty = json['bought_impact_qty'] as num;
    projectImpactQty = json['project_impact_qty'] as num;
    projectCompletion = json['project_completion'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['thumbnail_url'] = thumbnailUrl;
    data['funding_status'] = fundingStatus;
    return data;
  }
}
