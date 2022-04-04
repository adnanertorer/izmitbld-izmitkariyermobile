class WorkingTypeModel{
  int? workingTypeId;
  String? typeName;

  WorkingTypeModel({this.typeName, this.workingTypeId});

  factory WorkingTypeModel.fromJson(Map<String, Map> json) {
    return WorkingTypeModel(
        workingTypeId: json["workingTypeId"] as int,
        typeName: json["typeName"] as String);
  }
}