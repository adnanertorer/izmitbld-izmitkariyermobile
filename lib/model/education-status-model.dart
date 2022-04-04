class EducationStatusModel {
  int? educationStatusId;
  String? typeName;

  EducationStatusModel({this.typeName, this.educationStatusId});

  factory EducationStatusModel.fromJson(Map<String, Map> json) {
    return EducationStatusModel(
        educationStatusId: json["educationStatusId"] as int,
        typeName: json["typeName"] as String);
  }
}