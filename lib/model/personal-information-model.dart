class PersonelInformationModel{
  int? personalInformationId;
  int? memberId;
  int? gender;
  int? nationalityId;
  int? drivingLicense;
  bool? disabled;
  int? militaryService;
  double? expectationSalary;
  String? birthDate;
  String? militarDelayDate;
  int? professionId;
  int? maritalStatus;
  String? birthCity;

  PersonelInformationModel({
    this.professionId,
    this.militaryService,
    this.memberId,
    this.birthCity,
    this.birthDate,
    this.disabled,
    this.drivingLicense,
    this.expectationSalary,
    this.gender,
    this.maritalStatus,
    this.militarDelayDate,
    this.nationalityId,
    this.personalInformationId
  });

  factory PersonelInformationModel.fromJson(Map<String, Map> json) {
    return PersonelInformationModel(
      professionId: json["professionId"] as int,
      memberId: json["memberId"] as int,
      birthCity: json["birthCity"] as String,
      birthDate: json["birthDate"] as String,
      disabled: json["disabled"] as bool,
      drivingLicense: json["drivingLicense"] as int,
      expectationSalary: json["expectationSalary"] as double,
      gender: json["drivingLicense"] as int,
      maritalStatus: json["maritalStatus"] as int,
      militarDelayDate: json["militarDelayDate"] as String,
      militaryService: json["militaryService"] as int,
      nationalityId: json["nationalityId"] as int,
      personalInformationId: json["personalInformationId"] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    "professionId": this.professionId,
    "memberId": this.memberId,
    "birthCity": this.birthCity,
    "birthDate": this.birthDate,
    "disabled": this.disabled != null ? this.disabled : false,
    "drivingLicense": this.drivingLicense,
    "expectationSalary": this.expectationSalary,
    "gender": this.gender,
    "maritalStatus": this.maritalStatus,
    "memberId": this.memberId,
    "militarDelayDate": this.militarDelayDate == "null" ? null : this.militarDelayDate,
    "militaryService": this.militaryService,
    "nationalityId": this.nationalityId,
    "personalInformationId": this.personalInformationId
  };
}