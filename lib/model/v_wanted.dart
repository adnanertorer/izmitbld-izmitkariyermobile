import 'package:izmitbld_kariyer/model/v_wantad_prof.dart';

class VWanted{
  int? wantAdId;
  String? adName;
  String? deadline;
  int? educationCrtId;
  int? workingTypeId;
  String? workTypeName;
  int? genderCrtId;
  String? genderCriteriaName;
  int? ageCrtId;
  String? ageRangeName;
  bool? isEveryProf;
  String? description;
  int? nationalityCritId;
  String? natinalityCriteriaName;
  int? createdById;
  String? createdByName;
  String? createdBySurname;
  String? createdAt;
  String? changedAt;
  int? changedById;
  String? changedByName;
  String? changedBySurname;
  bool? isActive;
  bool? forConvict;
  bool? forDisabled;
  int? categoryId;
  String? categoryName;
  String? educationCriteriaName;
  List<VWantAdProf>? vWantAdProfsResources;

  VWanted({
    this.wantAdId,
    this.categoryName,
    this.categoryId,
    this.createdAt,
    this.createdBySurname,
    this.createdByName,
    this.adName,
    this.ageCrtId,
    this.ageRangeName,
    this.changedAt,
    this.changedById,
    this.changedByName,
    this.changedBySurname,
    this.createdById,
    this.deadline,
    this.description,
    this.educationCriteriaName,
    this.educationCrtId,
    this.forConvict,
    this.forDisabled,
    this.genderCriteriaName,
    this.genderCrtId,
    this.isActive,
    this.isEveryProf,
    this.natinalityCriteriaName,
    this.nationalityCritId,
    this.vWantAdProfsResources,
    this.workingTypeId,
    this.workTypeName
  });

  factory VWanted.fromJson(Map<String, Map> json){
    return VWanted(
      wantAdId: json["wantAdId"] as int,
      categoryName: json["categoryName"] as String,
      categoryId: json["categoryId"] as int,
      createdAt: json["createdAt"] as String,
      createdBySurname: json["createdBySurname"] as String,
      createdByName: json["createdByName"] as String,
      adName: json["adName"] as String,
      ageCrtId: json["ageCrtId"] as int,
      ageRangeName: json["ageRangeName"] as String,
      changedAt: json["changedAt"] as String,
      changedById: json["changedById"] as int,
      changedByName: json["changedByName"] as String,
      changedBySurname: json["changedBySurname"] as String,
      createdById: json["createdById"] as int,
      deadline: json["deadline"] as String,
      description: json["description"] as String,
      educationCriteriaName: json["educationCriteriaName"] as String,
      educationCrtId: json["educationCrtId"] as int,
      forConvict: json["forConvict"] as bool,
      forDisabled: json["forDisabled"] as bool,
      genderCriteriaName: json["genderCriteriaName"] as String,
      genderCrtId: json["genderCrtId"] as int,
      isActive: json["isActive"] as bool,
      isEveryProf: json["isEveryProf"] as bool,
      natinalityCriteriaName: json["natinalityCriteriaName"] as String,
      nationalityCritId: json["nationalityCritId"] as int,
      vWantAdProfsResources: json["vWantAdProfsResources"] as List<VWantAdProf>,
      workingTypeId: json["workingTypeId"] as int,
      workTypeName: json["workTypeName"] as String
    );
  }
}