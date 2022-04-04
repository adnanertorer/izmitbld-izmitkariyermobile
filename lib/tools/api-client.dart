import 'package:flutter/material.dart';
import 'package:izmitbld_kariyer/model/city-model.dart';
import 'package:izmitbld_kariyer/model/education-status-model.dart';
import 'package:izmitbld_kariyer/model/language-modal.dart';
import 'package:izmitbld_kariyer/model/scholar-model.dart';
import 'package:izmitbld_kariyer/model/school-type-model.dart';
import 'package:izmitbld_kariyer/model/select-item-model.dart';
import 'package:izmitbld_kariyer/model/select-year-model.dart';
import 'package:izmitbld_kariyer/model/teaching-type-model.dart';
import 'package:izmitbld_kariyer/model/v-education-model.dart';

import '../login.dart';
import 'SharedPreferencesHelper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient{

  Future<List<VEducationModel>> getEducations(BuildContext context) async {
    List<VEducationModel> educationList = <VEducationModel>[];
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl =
        SharedPreferencesHelper.getApiAddress() + "Education/VList";
    var response =
    await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      Map decoded = json.decode(response.body);
      for (var item in decoded["dynamicClass"]) {
        VEducationModel model = new VEducationModel();
        model.teachingTypeId = item["teachingTypeId"] as int;
        model.statusName = item["statusName"] as String;
        model.startDate = item["startDate"] as String;
        model.schoolTypeName = item["schoolTypeName"] as String;
        model.schoolTypeId = item["schoolTypeId"] as int;
        if(item["schoolSection"]!=null){
          model.schoolSection = item["schoolSection"] as String;
        }else{
          model.schoolSection = "";
        }
        model.schoolName = item["schoolName"] as String;
        model.scholarshipTypeId = item["scholarshipTypeId"] as int;
        model.scholarshipName = item["scholarshipName"] as String;
        model.memberId =  item["memberId"] as int;
        model.memberEducationId = item["memberEducationId"] as int;
        model.languageName = item["languageName"] as String;
        model.languageId =  item["languageId"] as int;
        if(item["finishDate"]!=null){
          model.finishDate = item["finishDate"] as String;
        }else{
          model.finishDate = "";
        }
        if(item["faculty"]!=null){
          model.faculty = item["faculty"] as String;
        }else{
          model.faculty = "";
        }
        model.educationStatusId = item["educationStatusId"] as int;
        if(item["diplomaGradeSystem"]!=null){
          model.diplomaGradeSystem = item["diplomaGradeSystem"] as String;
        }else{
          model.diplomaGradeSystem = "";
        }
        if(item["diplomaGrade"]!=null){
          model.diplomaGrade = item["diplomaGrade"] as String;
        }else{
          model.diplomaGrade = "";
        }
        if(item["description"]!=null){
          model.description = item["description"] as String;
        }else{
          model.description = "";
        }

        model.cityName = item["cityName"] as String;
        model.cityId = item["cityId"] as int;
        model.teachingTypeName = item["teachingTypeName"] as String;
        educationList.add(model);
      }
    } else if(response.statusCode == 401){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ));
    } else {
    }
    return educationList;
  }

  Future<List<SchoolType>> getSchoolTypes() async{
    List<SchoolType> schoolTypeList = <SchoolType>[];
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl =
        SharedPreferencesHelper.getApiAddress() + "SchoolType/List/";
    var response =
    await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      Map decoded = json.decode(response.body);
      for (var item in decoded["dynamicClass"]) {
        SchoolType model = new SchoolType();
        model.typeName = item["typeName"] as String;
        model.schoolTypeId = item["schoolTypeId"] as int;
        schoolTypeList.add(model);
      }
    }else{
    }
    return schoolTypeList;
  }

  Future<List<EducationStatusModel>> getEducationStatuses() async{
    List<EducationStatusModel> list = <EducationStatusModel>[];
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl =
        SharedPreferencesHelper.getApiAddress() + "BasicTypes/EducationStatusList/";
    var response =
    await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      Map decoded = json.decode(response.body);
      for (var item in decoded["dynamicClass"]) {
        EducationStatusModel model = new EducationStatusModel();
        model.typeName = item["typeName"] as String;
        model.educationStatusId = item["educationStatusId"] as int;
        list.add(model);
      }
    }else{
    }
    return list;
  }

  Future<List<CityModel>> getCities() async{
    List<CityModel> list = <CityModel>[];
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl =
        SharedPreferencesHelper.getApiAddress() + "Area/CityList/";
    var response =
    await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      Map decoded = json.decode(response.body);
      for (var item in decoded["dynamicClass"]) {
        CityModel model = new CityModel();
        model.cityId = item["cityId"] as int;
        model.cityName = item["cityName"] as String;
        list.add(model);
      }
    }else{
    }
    return list;
  }

  Future<List<SelectItemModel>> getGradleSystems() async{
    List<SelectItemModel> list = <SelectItemModel>[];
    list.add(new SelectItemModel(id: 0, value: "Seçiniz"));
    list.add(new SelectItemModel(id: 4, value: "4"));
    list.add(new SelectItemModel(id: 5, value: "5"));
    list.add(new SelectItemModel(id: 10, value: "10"));
    list.add(new SelectItemModel(id: 100, value: "100"));
    return list;
  }

  Future<List<SelectYearModel>> getYears() async{
    List<SelectYearModel> list = <SelectYearModel>[];
    for(int i=1983; i<2026;i++){
      try{
        SelectYearModel model = new SelectYearModel(valueStr: i.toString()+"-01-01", year: i);
        list.add(model);
      } catch(e){
        print(e);
      }
    }
    return list;
  }

  Future<List<SelectYearModel>> getFinishYears() async{
    List<SelectYearModel> list = <SelectYearModel>[];
    for(int i=1983; i<2026;i++){
      try{
        SelectYearModel model = new SelectYearModel(valueStr: i.toString()+"-01-01", year: i);
        list.add(model);
      } catch(e){
        print(e);
      }
    }
    return list;
  }


  Future<List<TeachingTypeModel>> getTeachingList() async{
    List<TeachingTypeModel> list = <TeachingTypeModel>[];
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl =
        SharedPreferencesHelper.getApiAddress() + "TeachingType/List/";
    var response =
    await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      Map decoded = json.decode(response.body);
      for (var item in decoded["dynamicClass"]) {
        TeachingTypeModel model = new TeachingTypeModel();
        model.typeName = item["typeName"] as String;
        model.teachingTypeId = item["teachingTypeId"] as int;
        list.add(model);
      }
    }else{
    }
    return list;
  }

  Future<List<LanguageModel>> getLanguages() async{
    List<LanguageModel> list = <LanguageModel>[];
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl =
        SharedPreferencesHelper.getApiAddress() + "BasicTypes/LanguageList/";
    var response =
    await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      Map decoded = json.decode(response.body);
      for (var item in decoded["dynamicClass"]) {
        LanguageModel model = new LanguageModel();
        model.name = item["name"] as String;
        model.languageId = item["languageId"] as int;
        list.add(model);
      }
    }else{
    }
    return list;
  }

  Future<List<ScholarModel>> getScholars() async{
    List<ScholarModel> list = <ScholarModel>[];
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl =
        SharedPreferencesHelper.getApiAddress() + "Scholarship/List/";
    var response =
    await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      Map decoded = json.decode(response.body);
      for (var item in decoded["dynamicClass"]) {
        ScholarModel model = new ScholarModel();
        model.typeName = item["typeName"] as String;
        model.scholarshipTypeId = item["scholarshipTypeId"] as int;
        list.add(model);
      }
    }else{
    }
    return list;
  }

}

