import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izmitbld_kariyer/model/city-model.dart';
import 'package:izmitbld_kariyer/model/education-status-model.dart';
import 'package:izmitbld_kariyer/model/member-education-model.dart';
import 'package:izmitbld_kariyer/model/school-type-model.dart';
import 'package:izmitbld_kariyer/model/select-item-model.dart';
import 'package:izmitbld_kariyer/model/select-year-model.dart';
import 'package:izmitbld_kariyer/model/v-education-model.dart';
import 'package:izmitbld_kariyer/tools/KariyerHelper.dart';
import 'package:izmitbld_kariyer/tools/SharedPreferencesHelper.dart';
import 'dart:convert';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:izmitbld_kariyer/tools/api-client.dart';

import '../nav_drawer.dart';

class EducationEdit extends StatefulWidget {
  final VEducationModel? memberEducationModel;

  EducationEdit({Key? key, @required this.memberEducationModel})
      : super(key: key);

  @override
  _EducationEditState createState() => _EducationEditState();
}

class _EducationEditState extends State<EducationEdit> {
  bool isLoading = false;
  bool isVisible = true;
  List<SchoolType> schoolTypeList = <SchoolType>[];
  SchoolType selectedSchoolType = new SchoolType();
  List<EducationStatusModel> educationStatusList = <EducationStatusModel>[];
  EducationStatusModel selectedEducationStatus = new EducationStatusModel();
  List<SelectItemModel> gradleSystemList = <SelectItemModel>[];
  SelectItemModel selectedGradleSystem = new SelectItemModel();
  List<CityModel> cityList = <CityModel>[];
  CityModel selectedCityModel = new CityModel();

  List<SelectYearModel> yearList = <SelectYearModel>[];
  List<SelectYearModel> finishYearList = <SelectYearModel>[];
  SelectYearModel selectedYear = new SelectYearModel();
  SelectYearModel selectedFinishYear = new SelectYearModel();

  var txtGradeNote = TextEditingController();
  var txtUnv = TextEditingController();
  var txtFaculty = TextEditingController();
  var txtSection = TextEditingController();

  ApiClient apiClient = new ApiClient();

  Future<void> getSchoolTypes() async {
    setState(() {
      isLoading = true;
    });
    schoolTypeList = await apiClient.getSchoolTypes();
    if (this.widget.memberEducationModel!.schoolTypeId != null) {
      selectedSchoolType = schoolTypeList
          .where((element) =>
              element.schoolTypeId ==
              this.widget.memberEducationModel!.schoolTypeId)
          .first;
    } else {
      selectedSchoolType = schoolTypeList.where((element) => element.schoolTypeId == 0).first;
    }
    setState(() {
      isLoading = false;
    });
    await getEducationStatuses();
  }

  Future<void> getEducationStatuses() async {
    setState(() {
      isLoading = true;
    });

    educationStatusList = await apiClient.getEducationStatuses();
    if (this.widget.memberEducationModel!.educationStatusId != null) {
      selectedEducationStatus = educationStatusList
          .where((element) =>
              element.educationStatusId ==
              this.widget.memberEducationModel!.educationStatusId)
          .first;
    } else {
      selectedEducationStatus = educationStatusList
          .where((element) =>
      element.educationStatusId == 0)
          .first;
    }
    setState(() {
      isLoading = false;
    });

    await getCities();
  }

  Future<void> getCities() async {
    setState(() {
      isLoading = true;
    });
    cityList = await apiClient.getCities();
    if (this.widget.memberEducationModel!.cityId != null) {
      selectedCityModel = cityList
          .where((element) =>
              element.cityId == this.widget.memberEducationModel!.cityId)
          .first;
    } else {
      selectedCityModel = cityList
          .where((element) =>
      element.cityId == 0)
          .first;
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> updateEducation() async {
    setState(() {
      isLoading = true;
    });
    String err = "";
    if(this.widget.memberEducationModel!.cityId==0){
      err+=", Şehir";
    }
    if(this.widget.memberEducationModel!.languageId == 0){
      this.widget.memberEducationModel!.languageId = 1;
    }
    if(this.widget.memberEducationModel!.scholarshipTypeId == 0){
      this.widget.memberEducationModel!.scholarshipTypeId = 4;
    }
    if(this.widget.memberEducationModel!.teachingTypeId == 0){
      err+=", Öğretim Tipi";
    }
    if(this.widget.memberEducationModel!.scholarshipTypeId == 0){
      err+=", Okul Türü";
    }

    if(this.widget.memberEducationModel!.startDate == "0"){
      err+=", Başlama Tarihi";
    }

    if(this.widget.memberEducationModel!.finishDate == "0"){
      err+=", Bitiş Tarihi";
    }

    if(err.trim().length > 0){
      await _showMyDialog("Lütfen şu bilgileri ($err) eksiksiz doldurunuz", "Eksik Bilgi", context);
    }else{
      print(this.widget.memberEducationModel!.startDate);
      if(this.widget.memberEducationModel!.startDate.toString().trim().length > 0 &&
          this.widget.memberEducationModel!.finishDate.toString().trim().length > 0){
        var startDateYear = DateTime.parse(this.widget.memberEducationModel!.startDate.toString()).year;
        var finishDateYear = DateTime.parse(this.widget.memberEducationModel!.finishDate.toString()).year;
        this.widget.memberEducationModel!.startDate = DateTime.parse(startDateYear.toString()+"-01-01T00:00:00").toIso8601String();
        this.widget.memberEducationModel!.finishDate =  DateTime.parse(finishDateYear.toString()+"-01-01T00:00:00").toIso8601String();
      }
      var token = await SharedPreferencesHelper.getTokenKey();
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };
      var toJson = this.widget.memberEducationModel!.toJson();
      var requestJson = convert.jsonEncode(toJson);
      String apiUrl = SharedPreferencesHelper.getApiAddress() + "Education/Update";
      var response =
      await http.post(Uri.parse(apiUrl), body: requestJson, headers: headers);
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        Map decoded = json.decode(response.body);
        var success = decoded["success"] as bool;
        if(success){
          await _showMyDialog("Eğitim bilgileri değiştirildi", "İşlem Başarılı", context);
        }else{
          var errorMessage = decoded["message"] as String;
          print(errorMessage);
          await _showMyDialog("Uygulamada bir sorun oluştu, lütfen tekrar deneyiniz", "İşlem Başarısız!", context);
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
  Future<void> _showMyDialog(
      String message, String title, BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> getGradleSystems() async{
    gradleSystemList = await apiClient.getGradleSystems();

    if (this.widget.memberEducationModel!.diplomaGradeSystem != null && this.widget.memberEducationModel!.diplomaGradeSystem != "") {
      selectedGradleSystem =  gradleSystemList.where((element) =>
      element.id ==
          int.parse(this
              .widget
              .memberEducationModel!
              .diplomaGradeSystem
              .toString()))
          .first;
    } else {
      selectedGradleSystem = gradleSystemList.where((element) => element.id == 0).first;
    }
    getSelectYears();
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          drawer: NavDrawer(),
          appBar: AppBar(
            title: Text(
                this.widget.memberEducationModel!.schoolName.toString() +
                    " Detay"),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context, false);
                }),
          ),
          resizeToAvoidBottomInset: true,
          // klavyenin text alanını ezmesini engeller
          body: Center(
            child: LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  reverse: false,
                  child: Column(children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: Text('Okul Türü'),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: DropdownButton<SchoolType>(
                        isExpanded: true,
                        value: selectedSchoolType,
                        icon: const Icon(Icons.arrow_circle_down_sharp),
                        iconSize: 24,
                        elevation: 16,
                        onChanged: (SchoolType? newValue) {
                          setState(() {
                            selectedSchoolType = newValue!;
                            this.widget.memberEducationModel!.schoolTypeId =
                                newValue.schoolTypeId;
                          });
                        },
                        items: schoolTypeList.map<DropdownMenuItem<SchoolType>>(
                            (SchoolType? value) {
                          return DropdownMenuItem<SchoolType>(
                            value: value,
                            child: Text(value!.typeName.toString()),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: Text('Başlangıç Tarihi'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: DropdownButton<SelectYearModel>(
                        isExpanded: true,
                        value: selectedYear,
                        icon: const Icon(Icons.arrow_circle_down_sharp),
                        iconSize: 24,
                        elevation: 16,
                        onChanged: (SelectYearModel? newValue) {
                          setState(() {
                            selectedYear = newValue!;
                            this.widget.memberEducationModel!.startDate = "01.01."+newValue.year.toString();
                          });
                        },
                        items: yearList.map<DropdownMenuItem<SelectYearModel>>(
                                (SelectYearModel? value) {
                              return DropdownMenuItem<SelectYearModel>(
                                value: value,
                                child: Text(value!.year.toString()),
                              );
                            }).toList(),
                      ),
                    ),
                    Padding(
                    padding: const EdgeInsets.only(
                    bottom: 8.0, left: 8.0, right: 8.0, top: 4.0),
                    child: Visibility(
                    visible: this.isVisible,
                    child:Column(
                      children: [ Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: Text('Bitiş Tarihi'),
                      ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: DropdownButton<SelectYearModel>(
                            isExpanded: true,
                            value: selectedFinishYear,
                            icon: const Icon(Icons.arrow_circle_down_sharp),
                            iconSize: 24,
                            elevation: 16,
                            onChanged: (SelectYearModel? newValue) {
                              setState(() {
                                selectedFinishYear = newValue!;
                                this.widget.memberEducationModel!.finishDate = newValue.year.toString()+"-01-01";
                              });
                            },
                            items: finishYearList.map<DropdownMenuItem<SelectYearModel>>(
                                    (SelectYearModel? value) {
                                  return DropdownMenuItem<SelectYearModel>(
                                    value: value,
                                    child: Text(value!.year.toString()),
                                  );
                                }).toList(),
                          ),
                        ),],
                    )),),

                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: Text('Eğitim Durumu'),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: DropdownButton<EducationStatusModel>(
                        isExpanded: true,
                        value: selectedEducationStatus,
                        icon: const Icon(Icons.arrow_circle_down_sharp),
                        iconSize: 24,
                        elevation: 16,
                        onChanged: (EducationStatusModel? newValue) {
                          setState(() {
                            selectedEducationStatus = newValue!;
                            this
                                .widget
                                .memberEducationModel!
                                .educationStatusId = newValue.educationStatusId;
                          });
                        },
                        items: educationStatusList
                            .map<DropdownMenuItem<EducationStatusModel>>(
                                (EducationStatusModel? value) {
                          return DropdownMenuItem<EducationStatusModel>(
                            value: value,
                            child: Text(value!.typeName.toString()),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                    padding: const EdgeInsets.only(
                    bottom: 8.0, left: 8.0, right: 8.0, top: 4.0),
                    child: Visibility(
                    visible: this.isVisible,
                    child:Column(
                    children: [
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: DropdownButton<SelectItemModel>(
                          isExpanded: true,
                          value: selectedGradleSystem,
                          icon: const Icon(Icons.arrow_circle_down_sharp),
                          iconSize: 24,
                          elevation: 16,
                          onChanged: (SelectItemModel? newValue) {
                            setState(() {
                              selectedGradleSystem = newValue!;
                              this
                                  .widget
                                  .memberEducationModel!
                                  .diplomaGradeSystem = newValue.id.toString();
                            });
                          },
                          items: gradleSystemList
                              .map<DropdownMenuItem<SelectItemModel>>(
                                  (SelectItemModel? value) {
                                return DropdownMenuItem<SelectItemModel>(
                                  value: value,
                                  child: Text(value!.value.toString()),
                                );
                              }).toList(),
                        ),
                      ),Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: Text('Diploma Not Sistemi'),
                      ),
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Diploma Notu"),
                          controller: txtGradeNote,
                          onChanged: (text) {
                            this.widget.memberEducationModel!.diplomaGrade = text;
                          },
                        ),
                      ),
                    ]),),),

                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Okul Adı"),
                        controller: txtUnv,
                        onChanged: (text) {
                          this.widget.memberEducationModel!.schoolName = text;
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: Text('İl'),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: DropdownButton<CityModel>(
                        isExpanded: true,
                        value: selectedCityModel,
                        icon: const Icon(Icons.arrow_circle_down_sharp),
                        iconSize: 24,
                        elevation: 16,
                        onChanged: (CityModel? newValue) {
                          setState(() {
                            selectedCityModel = newValue!;
                            this.widget.memberEducationModel!.cityId =
                                newValue.cityId;
                          });
                        },
                        items: cityList.map<DropdownMenuItem<CityModel>>(
                            (CityModel? value) {
                          return DropdownMenuItem<CityModel>(
                            value: value,
                            child: Text(value!.cityName.toString()),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: "Bölüm"),
                        controller: txtSection,
                        onChanged: (text) {
                          this.widget.memberEducationModel!.schoolSection =
                              text;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: new RaisedButton(
                          onPressed: () async => {
                            await updateEducation()
                          },
                          color: Colors.blue,
                          child: Text('Güncelle'),
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ]),
                );
              },
            ),
          ),
        ),
      );
  }

  Future<void> getSelectYears() async{

    yearList = await apiClient.getYears();
    if (this.widget.memberEducationModel!.startDate != null) {
      try{
        var dateStart = DateTime.parse(this.widget.memberEducationModel!.startDate.toString());
        if (yearList
            .where((element) =>
        element.year ==
            dateStart.year)
            .length >
            0) {
          selectedYear = yearList
              .where((element) =>
          element.year ==
              dateStart.year)
              .first;
        } else {
          selectedYear = yearList
              .where((element) =>
          element.year ==
              KariyerHelper.tempDateYear)
              .first;
        }
      }catch(ex){
        print(ex);
        selectedYear = yearList
            .where((element) =>
        element.year ==
            KariyerHelper.tempDateYear)
            .first;
      }

    } else {
      selectedYear = yearList
          .where((element) =>
      element.year ==
          KariyerHelper.tempDateYear)
          .first;
    }
    getFinishYears();

  }
  Future<void> getFinishYears() async{
    finishYearList = await apiClient.getFinishYears();
    if (this.widget.memberEducationModel!.finishDate != null) {
      try{
        var dateFinish = DateTime.parse(this.widget.memberEducationModel!.finishDate.toString());
        if (finishYearList
            .where((element) =>
        element.year ==
            dateFinish.year)
            .length >
            0) {
          selectedFinishYear = finishYearList
              .where((element) =>
          element.year ==
              dateFinish.year)
              .first;
        } else {
          selectedFinishYear = finishYearList
              .where((element) =>
          element.year ==
              KariyerHelper.tempDateYear)
              .first;
        }
      }catch(ex){
        print(ex);
        selectedFinishYear = finishYearList
            .where((element) =>
        element.year ==
            KariyerHelper.tempDateYear)
            .first;
      }

    } else {
      selectedFinishYear = finishYearList
          .where((element) =>
      element.year ==
          KariyerHelper.tempDateYear)
          .first;
    }
    getSchoolTypes();
  }

  @override
  void initState() {
    super.initState();

    if( this.widget.memberEducationModel!.educationStatusId != 3){
      this.widget.memberEducationModel!.finishDate =null;
      this.isVisible = false;
    }
    txtGradeNote.text =
        this.widget.memberEducationModel!.diplomaGradeSystem.toString();
    txtUnv.text = this.widget.memberEducationModel!.schoolName.toString();
    txtSection.text =
        this.widget.memberEducationModel!.schoolSection.toString();

    getGradleSystems();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
