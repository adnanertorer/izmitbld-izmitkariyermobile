class MaritalStatusModel{
  int? maritalStatusId;
  String? maritalStatus;

  MaritalStatusModel({this.maritalStatus, this.maritalStatusId});

  factory MaritalStatusModel.fromJson(Map<String, Map> json){
    return MaritalStatusModel(
        maritalStatusId: json["maritalStatusId"] as int,
        maritalStatus: json["maritalStatus"] as String
    );
  }
}