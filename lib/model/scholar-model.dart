class ScholarModel{
  int? scholarshipTypeId;
  String? typeName;

  ScholarModel({this.scholarshipTypeId, this.typeName});

  factory ScholarModel.fromJson(Map<String, Map> json){
    return ScholarModel(
        scholarshipTypeId: json["scholarshipTypeId"] as int,
        typeName: json["typeName"] as String
    );

  }
  Map<String, dynamic> toJson() => {
    "scholarshipTypeId": this.scholarshipTypeId,
    "typeName": this.typeName,
  };
}