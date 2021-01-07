class ProjectDetailsModel {
  bool success;
  String message;
  Data data;

  ProjectDetailsModel({this.data, this.message, this.success});

  ProjectDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] as bool;
    message = json['message'] as String;
    data = json['data'] != null
        ? Data.fromJson(json['data'] as Map<String, dynamic>)
        : null;
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
  String name, thumbnailUrl, plantationSize, plantingDensity, community;
  int totalNoOfTrees, id, femaleEmpTarget, plantingBalance;
  int conservationBalance, fundsRaised, totalFundingTarget;
  List<MapSegmentation> mapSegmentation;

  Data(
      {this.id,
      this.name,
      this.thumbnailUrl,
      this.mapSegmentation,
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
    if (json['map_segmentation'] != null) {
      mapSegmentation = <MapSegmentation>[];
      json['map_segmentation'].forEach((v) {
        mapSegmentation
            .add(MapSegmentation.fromJson(v as Map<String, dynamic>));
      });
    }
    plantationSize = json['plantation_size'] as String;
    plantingDensity = json['planting_density'] as String;
    totalNoOfTrees = json['total_no_of_trees'] as int;
    community = json['community'] as String;
    femaleEmpTarget = json['female_emp_target'] as int;
    plantingBalance = json['planting_balance'] as int;
    conservationBalance = json['conservation_balance'] as int;
    fundsRaised = json['funds_raised'] as int;
    totalFundingTarget = json['total_funding_target'] as int;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['thumbnail_url'] = thumbnailUrl;
    if (mapSegmentation != null) {
      data['map_segmentation'] =
          mapSegmentation.map((v) => v.toJson()).toList();
    }
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

class MapSegmentation {
  int id;
  String type, color;
  List<Coordinates> coordinates;
  double plantingArea;

  MapSegmentation(
      {this.id, this.type, this.color, this.coordinates, this.plantingArea});

  MapSegmentation.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    type = json['type'] as String;
    color = json['color'] as String;
    if (json['coordinates'] != null) {
      coordinates = <Coordinates>[];
      json['coordinates'].forEach((v) {
        coordinates.add(Coordinates.fromJson(v as Map<String, dynamic>));
      });
    }
    plantingArea = json['plantingArea'] as double;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['color'] = color;
    if (coordinates != null) {
      data['coordinates'] = coordinates.map((v) => v.toJson()).toList();
    }
    data['plantingArea'] = plantingArea;
    return data;
  }
}

class Coordinates {
  double lat, lng;

  Coordinates({this.lat, this.lng});

  Coordinates.fromJson(Map<String, dynamic> json) {
    lat = json['lat'] as double;
    lng = json['lng'] as double;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}
