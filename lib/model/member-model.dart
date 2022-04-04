class Member {
  int? memberId;
  String? name;
  String? surname;
  String? tcIdendtityNumber;
  String? phone;
  String? email;
  String? password;
  bool? isActive;
  DateTime? createdAt;
  String? refresfToken;
  DateTime? refreshTokenEndDate;
  int? cityId;
  int? districtId;
  String? summaryText;
  String? profileImage;
  bool? approvedKvkk;
  bool? approvedClarification;
  int? vocation;
  int? graduation;
  int? birthYear;
  int? gender;
  int? militaryService;
  String? militarDelayDate;
  String? cityName;
  String? districtName;

  Member(
      {this.approvedClarification,
      this.approvedKvkk,
      this.birthYear,
      this.cityId,
      this.createdAt,
      this.districtId,
      this.email,
      this.gender,
      this.graduation,
      this.isActive,
      this.memberId,
      this.militarDelayDate,
      this.militaryService,
      this.name,
      this.password,
      this.phone,
      this.profileImage,
      this.refresfToken,
      this.refreshTokenEndDate,
      this.summaryText,
      this.surname,
      this.tcIdendtityNumber,
      this.vocation,
      this.cityName,
      this.districtName});

  factory Member.fromJson(Map<String, Map> json) {
    return Member(
      approvedClarification: json["approvedClarification"] as bool,
      approvedKvkk: json["approvedKvkk"] as bool,
      birthYear: json["birthYear"] as int,
      cityId: json["cityId"] as int,
      createdAt: json["createdAt"] as DateTime,
      districtId: json["districtId"] as int,
      email: json["email"] as String,
      gender: json["gender"] as int,
      graduation: json["graduation"] as int,
      isActive: json["isActive"] as bool,
      memberId: json["memberId"] as int,
      militarDelayDate: json["militarDelayDate"] as String,
      militaryService: json["militaryService"] as int,
      name: json["name"] as String,
      password: json["password"] as String,
      phone: json["phone"] as String,
      profileImage: json["profileImage"] as String,
      refresfToken: json["refresfToken"] as String,
      refreshTokenEndDate: json["refreshTokenEndDate"] as DateTime,
      summaryText: json["summaryText"] as String,
      surname: json["surname"] as String,
      tcIdendtityNumber: json["tcIdendtityNumber"] as String,
      vocation: json["vocation"] as int,
      cityName: json["cityName"] as String,
      districtName: json["districtName"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        "approvedClarification": this.approvedClarification,
        "approvedKvkk": this.approvedKvkk,
        "birthYear": this.birthYear,
        "cityId": this.cityId,
        "createdAt": this.createdAt!=null ? this.createdAt?.toIso8601String() : DateTime.now().toIso8601String(),
        "districtId": this.districtId,
        "email": this.email,
        "gender": this.gender,
        "graduation": this.graduation,
        "isActive": this.isActive!=null ? this.isActive : true,
        "memberId": this.memberId,
        "militarDelayDate": this.militarDelayDate,
        "militaryService": this.militaryService,
        "name": this.name,
        "password": this.password,
        "phone": this.phone,
        "profileImage": this.profileImage,
        "refresfToken": this.refresfToken,
        "refreshTokenEndDate": this.refreshTokenEndDate,
        "summaryText": this.summaryText,
        "surname": this.surname,
        "tcIdendtityNumber": this.tcIdendtityNumber,
        "vocation": this.vocation,
        "cityName": this.cityName,
        "districtName": this.districtName
      };
}
