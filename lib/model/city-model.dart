class CityModel {
  int? cityId;
  String? cityName;

  CityModel({
    this.cityId,
    this.cityName
  });

  factory CityModel.fromJson(Map<String, Map> json){
    return CityModel(
        cityId: json["cityId"] as int,
        cityName: json["cityName"] as String
    );
  }
}