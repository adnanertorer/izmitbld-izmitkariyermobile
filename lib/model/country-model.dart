class CountryModel{
  int? countryId;
  String? countryName;

  CountryModel({this.countryId, this.countryName});

  factory CountryModel.fromJson(Map<String, Map> json) {
    return CountryModel(
        countryId: json["countryId"] as int,
        countryName: json["countryName"] as String);
  }


}