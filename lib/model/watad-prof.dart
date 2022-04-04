class WantAdProf{
  int? wantAdMainProfId;
  int? professionId;
  int? wantAdId;
  int? professionName;
  int? professionCode;

  WantAdProf({
    this.professionCode,
    this.professionId,
    this.professionName,
    this.wantAdId,
    this.wantAdMainProfId
  });

  factory WantAdProf.fromJson(Map<String, Map> json){
    return WantAdProf(
      wantAdId: json["wantAdId"] as int,
      professionCode: json["professionCode"] as int,
      professionId: json["professionId"] as int,
      professionName: json["professionName"] as int,
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