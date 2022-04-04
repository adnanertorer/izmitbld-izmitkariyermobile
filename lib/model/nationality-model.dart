class NationalityModel{
  int? nationalityTypeId;
  String? typeName;

  NationalityModel({this.nationalityTypeId, this.typeName});

  factory NationalityModel.fromJson(Map<String, Map> json){
    return NationalityModel(
        nationalityTypeId: json["nationalityTypeId"] as int,
        typeName: json["typeName"] as String
    );
  }
}