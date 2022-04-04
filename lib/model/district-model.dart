class DistrictModel {
  int? districtId;
  int? cityId;
  String? districtName;

  DistrictModel({
    this.districtId,
    this.cityId,
    this.districtName
  });

  factory DistrictModel.fromJson(Map<String, Map> json){
    return DistrictModel(
        districtId: json["districtId"] as int,
        cityId: json["cityId"] as int,
        districtName: json["districtName"] as String
    );
  }
}