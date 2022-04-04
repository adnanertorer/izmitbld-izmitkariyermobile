class VWantAdProf{
  int? wantAdMainProfId;
  int? professionId;
  int? wantAdId;
  String? professionName;
  String? professionCode;

  VWantAdProf({
    this.professionCode,
    this.professionId,
    this.professionName,
    this.wantAdId,
    this.wantAdMainProfId
  });

  factory VWantAdProf.fromJson(Map<String, Map> json){
    return VWantAdProf(
        wantAdId: json["wantAdId"] as int,
        professionCode: json["professionCode"] as String,
        professionId: json["professionId"] as int,
        professionName: json["professionName"] as String,
        wantAdMainProfId: json["wantAdMainProfId"] as int
    );
  }

  Map<String, dynamic> toJson() => {
    "wantAdId": this.wantAdId,
    "professionCode": this.professionCode,
    "professionId": this.professionId,
    "professionName": this.professionName,
    "wantAdMainProfId": this.wantAdMainProfId
  };
}