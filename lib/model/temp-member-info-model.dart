class TempMemberInfoModel{
  String? tcNumber;
  String? smscCode;
  String? password;
  String? passwordAgain;

  TempMemberInfoModel({this.password, this.passwordAgain, this.smscCode, this.tcNumber});

  factory TempMemberInfoModel.fromJson(Map<String, Map> json){
    return TempMemberInfoModel(
        tcNumber: json["tcNumber"] as String,
        smscCode: json["smscCode"] as String,
        password: json["password"] as String,
        passwordAgain: json["passwordAgain"] as String
    );
  }

  Map<String, dynamic> toJson() => {
    "tcNumber": this.tcNumber,
    "smscCode": this.smscCode,
    "password": this.password,
    "passwordAgain": this.passwordAgain
  };
}