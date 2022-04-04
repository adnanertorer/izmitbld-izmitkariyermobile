class MemberExperienceModel{
  int? memberExperienceId;
  int? memberId;
  String? firmName;
  String? position;
  String? startDate;
  String? finishDate;
  bool? isWorking;
  int? sectorId;
  int? businessAreaId;
  int? workingTypeId;
  int? countryId;
  int? cityId;
  String? description;

  MemberExperienceModel({
    this.memberId,
    this.cityId,
    this.description,
    this.workingTypeId,
    this.businessAreaId,
    this.countryId,
    this.finishDate,
    this.firmName,
    this.isWorking,
    this.memberExperienceId, this.position, this.sectorId, this.startDate
  });

  factory MemberExperienceModel.fromJson(Map<String, Map> json) {
    return MemberExperienceModel(
      memberExperienceId: json["memberExperienceId"] as int,
      memberId: json["memberId"] as int,
      cityId: json["cityId"] as int,
      workingTypeId: json["workingTypeId"] as int,
      description: json["description"] as String,
      businessAreaId: json["businessAreaId"] as int,
      countryId: json["countryId"] as int,
      finishDate: json["finishDate"] as String,
      firmName: json["firmName"] as String,
      isWorking: json["isWorking"] as bool,
      position: json["position"] as String,
      sectorId: json["sectorId"] as int,
      startDate: json["startDate"] as String
    );
  }

  Map<String, dynamic> toJson() => {
    "memberExperienceId": this.memberExperienceId,
    "memberId": this.memberId,
    "cityId": this.cityId,
    "workingTypeId": this.workingTypeId,
    "description": this.description,
    "businessAreaId": this.businessAreaId,
    "countryId": this.countryId,
    "finishDate": this.finishDate,
    "firmName": this.firmName,
    "isWorking": this.isWorking,
    "position": this.position,
    "sectorId": this.sectorId,
    "startDate": this.startDate
  };
}