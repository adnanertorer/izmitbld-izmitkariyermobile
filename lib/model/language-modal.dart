class LanguageModel{
  int? languageId;
  String? name;

  LanguageModel({this.languageId, this.name});

  factory LanguageModel.fromJson(Map<String, Map> json){
    return LanguageModel(
        languageId: json["languageId"] as int,
        name: json["name"] as String
    );

  }
  Map<String, dynamic> toJson() => {
    "languageId": this.languageId,
    "name": this.name,
  };
}