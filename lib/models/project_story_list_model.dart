import 'package:gmt_planter/models/pagination.dart';

class ProjectStoryListmodel {
  List<Story> items;
  Pagination pagination;

  ProjectStoryListmodel({this.items});

  ProjectStoryListmodel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Story>[];
      json['items'].forEach((v) {
        items.add(Story.fromJson(v as Map<String, dynamic>));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (items != null) {
      data['items'] = items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Story {
  List<Project> project;
  int storyId, captionId;
  String storyTitle, storyDescription, impactPartnerTitle, thumbnailUrl, caption;

  Story({
    this.storyId,
    this.storyTitle,
    this.storyDescription,
    this.impactPartnerTitle,
    this.thumbnailUrl,
    this.caption,
    this.captionId,
    this.project,
  });

  Story.fromJson(Map<String, dynamic> json) {
    storyId = json['story_id'] as int;
    storyTitle = json['story_title'] as String;
    storyDescription = json['story_description'] as String;
    impactPartnerTitle = json['impact_partner_title'] as String;
    thumbnailUrl = json['thumbnail_url'] as String;
    caption = json['caption'] as String;
    captionId = json['caption_id'] as int;
    if (json['project'] != null) {
      project = <Project>[];
      json['project'].forEach((v) {
        project.add(Project.fromJson(v as Map<String, dynamic>));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['story_id'] = storyId;
    data['story_title'] = storyTitle;
    data['story_description'] = storyDescription;
    data['impact_partner_title'] = impactPartnerTitle;
    data['thumbnail_url'] = thumbnailUrl;
    data['caption'] = caption;
    data['caption_id'] = captionId;
    if (project != null) {
      data['project'] = project.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Project {
  int projectId;
  String projectName;

  Project({this.projectId, this.projectName});

  Project.fromJson(Map<String, dynamic> json) {
    projectId = json['project_id'] as int;
    projectName = json['project_name'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['project_id'] = projectId;
    data['project_name'] = projectName;
    return data;
  }
}
