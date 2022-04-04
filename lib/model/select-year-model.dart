class SelectYearModel {
  String? valueStr;
  int? year;

  SelectYearModel({this.year, this.valueStr});

  factory SelectYearModel.fromJson(Map<String, Map> json) {
    return SelectYearModel(
        year: json["year"] as int, valueStr: json["valueStr"] as String);
  }

  Map<String, dynamic> toJson() => {
        "year": this.year,
        "valueStr": this.valueStr,
      };
}
