class MemberEducationModel {
  int? memberEducationId;
  String? startDate;
  String? finishDate;
  bool? isResume;
  bool? isLeave;
  int? educationStatusId;
  String? diplomaGradeSystem;
  String? diplomaGrade;
  int? schoolTypeId;
  String? schoolName;
  int? cityId;
  String? faculty;
  String? schoolSection;
  int? teachingTypeId;
  int? scholarshipTypeId;
  int? languageId;
  String? description;

  MemberEducationModel(
      {this.finishDate,
      this.startDate,
      this.cityId,
      this.description,
      this.schoolTypeId,
      this.diplomaGrade,
      this.diplomaGradeSystem,
      this.educationStatusId,
      this.faculty,
      this.isLeave,
      this.isResume,
      this.languageId,
      this.memberEducationId,
      this.scholarshipTypeId,
      this.schoolName,
      this.schoolSection,
      this.teachingTypeId});

  factory MemberEducationModel.fromJson(Map<String, Map> json) {
    return MemberEducationModel(
        startDate: json["startDate"] as String,
        finishDate: json["finishDate"] as String,
        description: json["description"] as String,
        cityId: json["cityId"] as int,
        diplomaGrade: json["diplomaGrade"] as String,
        diplomaGradeSystem: json["diplomaGradeSystem"] as String,
        educationStatusId: json["educationStatusId"] as int,
        faculty: json["faculty"] as String,
        isLeave: json["faculty"] as bool,
        isResume: json["faculty"] as bool,
        languageId: json["languageId"] as int,
        memberEducationId: json["memberEducationId"] as int,
        scholarshipTypeId: json["scholarshipTypeId"] as int,
        schoolName: json["schoolName"] as String,
        schoolSection: json["schoolSection"] as String,
        schoolTypeId: json["schoolTypeId"] as int,
        teachingTypeId: json["teachingTypeId"] as int);
  }

  Map<String, dynamic> toJson() => {
    "startDate": this.startDate,
    "finishDate": this.finishDate,
    "description": this.description,
    "cityId": this.cityId,
    "diplomaGrade": this.diplomaGrade,
    "diplomaGradeSystem": this.diplomaGradeSystem,
    "educationStatusId": this.educationStatusId,
    "faculty": this.faculty,
    "isLeave": this.isLeave,
    "isResume": this.isResume,
    "languageId": this.languageId,
    "memberEducationId": this.memberEducationId,
    "scholarshipTypeId": this.scholarshipTypeId,
    "schoolName": this.schoolName,
    "schoolSection": this.schoolSection,
    "schoolTypeId": this.schoolTypeId,
    "teachingTypeId": this.teachingTypeId,
  };
}
