class SchoolType {
  int? schoolTypeId;
  String? typeName;

  SchoolType({this.schoolTypeId, this.typeName});

  factory SchoolType.fromJson(Map<String, Map> json) {
    return SchoolType(
        schoolTypeId: json["schoolTypeId"] as int,
        typeName: json["typeName"] as String);
  }
}
