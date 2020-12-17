class ProjectListModel {
  Data data;

  ProjectListModel({this.data});

  ProjectListModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data'] as Map<String, dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<ProjectModel> notDeployedProjects, activeFundingProjects, activeManagementProjects;

  Data({this.notDeployedProjects, this.activeFundingProjects, this.activeManagementProjects});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['NOT_YET_DEPLOYED'] != null) {
      notDeployedProjects = <ProjectModel>[];
      json['NOT_YET_DEPLOYED'].forEach((v) {
        notDeployedProjects.add(ProjectModel.fromJson(v as Map<String, dynamic>));
      });
    }
    if (json['ACTIVE_FUNDING'] != null) {
      activeFundingProjects = <ProjectModel>[];
      json['ACTIVE_FUNDING'].forEach((v) {
        activeFundingProjects.add(ProjectModel.fromJson(v as Map<String, dynamic>));
      });
    }
    if (json['ACTIVE_MANAGEMENT'] != null) {
      activeManagementProjects = <ProjectModel>[];
      json['ACTIVE_MANAGEMENT'].forEach((v) {
        activeManagementProjects.add(ProjectModel.fromJson(v as Map<String, dynamic>));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (notDeployedProjects != null) {
      data['NOT_YET_DEPLOYED'] = notDeployedProjects.map((v) => v.toJson()).toList();
    }
    if (activeFundingProjects != null) {
      data['ACTIVE_FUNDING'] = activeFundingProjects.map((v) => v.toJson()).toList();
    }
    if (activeManagementProjects != null) {
      data['ACTIVE_MANAGEMENT'] = activeManagementProjects.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProjectModel {
  int id;
  String name, thumbnailUrl, fundingStatus;

  ProjectModel({this.id, this.name, this.thumbnailUrl, this.fundingStatus});

  ProjectModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    name = json['name'] as String;
    thumbnailUrl = json['thumbnail_url'] as String;
    fundingStatus = json['funding_status'] as String;
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
