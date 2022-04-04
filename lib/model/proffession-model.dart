class Profession{
  int? professionId;
  String? professionName;
  String? professionCode;

  Profession({
    this.professionName, this.professionCode, this.professionId
  });

  factory Profession.fromJson(Map<String, Map> json){
    return Profession(
        professionId: json["professionId"] as int,
        professionName: json["professionName"] as String,
        professionCode: json["professionCode"] as String
    );
  }

  Map<String, dynamic> toJson() => {
    "professionId": this.professionId,
    "professionName": this.professionName,
    "professionCode": this.professionCode,
  };

}