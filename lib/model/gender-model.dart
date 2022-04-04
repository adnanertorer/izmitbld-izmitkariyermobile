class GenderModel {
  int? genderId;
  String? genderName;

  GenderModel({
    this.genderId,
    this.genderName
  });

  factory GenderModel.fromJson(Map<String, Map> json){
    return GenderModel(
        genderId: json["genderId"] as int,
        genderName: json["genderName"] as String
    );
  }
}