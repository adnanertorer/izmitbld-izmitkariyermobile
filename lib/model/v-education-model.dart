class VEducationModel {
  int? memberEducationId;
  int? memberId;
  String? startDate;
  String? finishDate;
  int? educationStatusId;
  String? statusName;
  String? diplomaGradeSystem;
  String? diplomaGrade;
  int? schoolTypeId;
  String? schoolTypeName;
  String? schoolName;
  int? cityId;
  String? cityName;
  String? faculty;
  String? schoolSection;
  int? teachingTypeId;
  String? teachingTypeName;
  int? scholarshipTypeId;
  String? scholarshipName;
  int? languageId;
  String? languageName;
  String? description;

  VEducationModel(
      {this.cityId,
      this.cityName,
      this.description,
      this.diplomaGrade,
      this.diplomaGradeSystem,
      this.educationStatusId,
      this.faculty,
      this.finishDate,
      this.languageId,
      this.languageName,
      this.memberEducationId,
      this.memberId,
      this.scholarshipName,
      this.scholarshipTypeId,
      this.schoolName,
      this.schoolSection,
      this.schoolTypeId,
      this.schoolTypeName,
      this.startDate,
      this.statusName,
      this.teachingTypeId,
      this.teachingTypeName});

  factory VEducationModel.fromJson(Map<String, Map> json) {
    return VEducationModel(
      cityId: json["cityId"] as int,
      cityName: json["cityName"] as String,
      description: json["description"] as String,
      diplomaGrade: json["diplomaGrade"] as String,
      diplomaGradeSystem: json["diplomaGradeSystem"] as String,
      educationStatusId: json["educationStatusId"] as int,
      faculty: json["faculty"] as String,
      finishDate: json["finishDate"] as String,
      languageId: json["languageId"] as int,
      languageName: json["languageName"] as String,
      memberEducationId: json["memberEducationId"] as int,
      memberId: json["memberId"] as int,
      scholarshipName: json["scholarshipName"] as String,
      scholarshipTypeId: json["scholarshipTypeId"] as int,
      schoolName: json["schoolName"] as String,
      schoolSection: json["schoolSection"] as String,
      schoolTypeId: json["schoolTypeId"] as int,
      schoolTypeName: json["schoolTypeName"] as String,
      startDate: json["startDate"] as String,
      statusName: json["statusName"] as String,
      teachingTypeId: json["teachingTypeId"] as int,
      teachingTypeName: json["teachingTypeName"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    "cityId": this.cityId,
    "cityName": this.cityName,
    "description": this.description,
    "diplomaGrade": this.diplomaGrade,
    "diplomaGradeSystem": this.diplomaGradeSystem,
    "educationStatusId": this.educationStatusId,
    "faculty": this.faculty,
    "finishDate": this.finishDate,
    "languageId": this.languageId,
    "languageName": this.languageName,
    "memberEducationId": this.memberEducationId,
    "memberId": this.memberId,
    "scholarshipName": this.scholarshipName,
    "scholarshipTypeId": this.scholarshipTypeId,
    "schoolName": this.schoolName,
    "schoolSection": this.schoolSection,
    "schoolTypeId": this.schoolTypeId,
    "schoolTypeName": this.schoolTypeName,
    "startDate": this.startDate,
    "statusName": this.statusName,
    "teachingTypeId": this.teachingTypeId,
    "teachingTypeName": this.teachingTypeName,
  };
}
