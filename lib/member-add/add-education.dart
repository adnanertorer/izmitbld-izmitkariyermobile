import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:izmitbld_kariyer/member_details/member-education.dart';
import 'package:izmitbld_kariyer/model/city-model.dart';
import 'package:izmitbld_kariyer/model/education-status-model.dart';
import 'package:izmitbld_kariyer/model/language-modal.dart';
import 'package:izmitbld_kariyer/model/member-education-model.dart';
import 'package:izmitbld_kariyer/model/scholar-model.dart';
import 'package:izmitbld_kariyer/model/school-type-model.dart';
import 'package:izmitbld_kariyer/model/select-item-model.dart';
import 'package:izmitbld_kariyer/model/select-year-model.dart';
import 'package:izmitbld_kariyer/model/teaching-type-model.dart';
import 'package:izmitbld_kariyer/tools/SharedPreferencesHelper.dart';
import 'package:izmitbld_kariyer/tools/api-client.dart';
import 'dart:convert';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../nav_drawer.dart';

final spinkit = SpinKitFadingCircle(
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: index.isEven ? Colors.red : Colors.green,
      ),
    );
  },
);

class AddEducation extends StatefulWidget {
  @override
  _AddEducationState createState() => _AddEducationState();
}

class _AddEducationState extends State<AddEducation> {
  MemberEducationModel memberEducetionModel = new MemberEducationModel();
  SchoolType selectedSchoolType = new SchoolType();
  List<SchoolType> schoolTypeList = <SchoolType>[];
  List<SelectYearModel> yearList = <SelectYearModel>[];
  List<SelectYearModel> finishYearList = <SelectYearModel>[];
  List<CityModel> cities = <CityModel>[];
  List<EducationStatusModel> educationStatusList = <EducationStatusModel>[];
  List<TeachingTypeModel> teachingList = <TeachingTypeModel>[];
  List<LanguageModel> languageList = <LanguageModel>[];
  List<ScholarModel> scholarList = <ScholarModel>[];
  List<SelectItemModel> gradleSystemList = <SelectItemModel>[];

  SelectYearModel selectedYear = new SelectYearModel();
  SelectYearModel selectedFinishYear = new SelectYearModel();
  EducationStatusModel selectedEducationModel = new EducationStatusModel();
  CityModel selectedCity = new CityModel();
  TeachingTypeModel selectedTeachingModel = new TeachingTypeModel();
  LanguageModel selectedLanguge = LanguageModel();
  ScholarModel selectedScholar = new ScholarModel();
  SelectItemModel selectedGradleSystem = new SelectItemModel();

  final txtGradle = TextEditingController();
  final txtSchoolName = TextEditingController();
  final txtFaculty = TextEditingController();
  final txtSchoolSection = TextEditingController();
  final txtDescription = TextEditingController();
  String schoolNameTitle = "Okul Adı";

  bool isFinish = true;
  bool isHighSchool = false;
  bool isResume = false;
  bool isLive = false;

  Future<void> getEducationStatuses() async {
    setState(() {
      isLoading = true;
    });
    educationStatusList = await apiClient.getEducationStatuses();
    EducationStatusModel model =
        new EducationStatusModel(typeName: "Seçiniz", educationStatusId: 0);
    educationStatusList.add(model);
    selectedEducationModel = educationStatusList
        .where((element) => element.educationStatusId == 0)
        .first;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getSchoolType() async {
    setState(() {
      isLoading = true;
    });
    schoolTypeList = await apiClient.getSchoolTypes();
    SchoolType type = new SchoolType(schoolTypeId: 0, typeName: "Seçiniz");
    schoolTypeList.add(type);
    selectedSchoolType =
        schoolTypeList.where((element) => element.schoolTypeId == 0).first;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getCities() async {
    setState(() {
      isLoading = true;
    });
    cities = await apiClient.getCities();
    CityModel model = new CityModel(cityId: 0, cityName: "Seçiniz");
    cities.add(model);
    selectedCity = cities.where((element) => element.cityId == 0).first;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getTeachingList() async {
    setState(() {
      isLoading = true;
    });
    teachingList = await apiClient.getTeachingList();
    TeachingTypeModel model = new TeachingTypeModel();
    model.typeName = "Seçiniz";
    model.teachingTypeId = 0;
    teachingList.add(model);
    selectedTeachingModel =
        teachingList.where((element) => element.teachingTypeId == 0).first;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getLanguages() async {
    setState(() {
      isLoading = true;
    });
    languageList = await apiClient.getLanguages();
    LanguageModel model = new LanguageModel(languageId: 0, name: "Seçiniz");
    languageList.add(model);
    selectedLanguge =
        languageList.where((element) => element.languageId == 0).first;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getScholars() async {
    setState(() {
      isLoading = true;
    });
    scholarList = await apiClient.getScholars();
    ScholarModel model =
        new ScholarModel(typeName: "Seçiniz", scholarshipTypeId: 0);
    scholarList.add(model);
    selectedScholar =
        scholarList.where((element) => element.scholarshipTypeId == 0).first;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> addEducation() async {
    if (this.memberEducetionModel.languageId != 0 &&
        this.memberEducetionModel.teachingTypeId != 0 &&
        this.memberEducetionModel.scholarshipTypeId != 0 &&
        this.memberEducetionModel.cityId != 0 &&
        this.memberEducetionModel.schoolTypeId != 0 &&
        this.memberEducetionModel.schoolName.toString().trim().length > 0 &&
        this.memberEducetionModel.educationStatusId != 0 &&
        this.memberEducetionModel.startDate.toString().trim().length > 0) {
      setState(() {
        isLoading = true;
      });
      var token = await SharedPreferencesHelper.getTokenKey();
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };

      try {
        if (this.memberEducetionModel.finishDate != null) {
          if (this.memberEducetionModel.finishDate.toString().trim().length >
              0) {
            this.memberEducetionModel.finishDate =
                DateTime.parse(this.memberEducetionModel.finishDate.toString())
                    .toIso8601String();
          } else {
            this.memberEducetionModel.finishDate = null;
          }
        }
        this.memberEducetionModel.startDate =
            DateTime.parse(this.memberEducetionModel.startDate.toString())
                .toIso8601String();
        print(this.memberEducetionModel.startDate);
      } catch (ex) {
        print(ex);
      }

      var toJson = this.memberEducetionModel.toJson();
      var requestJson = convert.jsonEncode(toJson);
      String apiUrl = SharedPreferencesHelper.getApiAddress() + "Education/Add";
      var response = await http.post(Uri.parse(apiUrl),
          body: requestJson, headers: headers);
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        Map decoded = json.decode(response.body);
        var success = decoded["success"] as bool;
        if (success) {
          await _showMyDialog(
              "Eğitim bilginiz eklendi", "İşlem Başarılı", context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MemberEducation(),
              ));
        } else {
          setState(() {
            isLoading = false;
          });
          var errorMessage = decoded["message"] as String;
          print(errorMessage);
          await _showMyDialog(
              "Uygulamada bir sorun oluştu, lütfen tekrar deneyiniz",
              "İşlem Başarısız!",
              context);
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      _showMyDialog(
          "Lütfen eksik bilgileri tamamlayın", "Eksik Bilgi Girişi", context);
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

  bool isLoading = false;
  ApiClient apiClient = new ApiClient();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text("Okul Ekle"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, false);
              }),
        ),
        resizeToAvoidBottomInset: true,
        // klavyenin text alanını ezmesini engeller
        body: Center(
          child: LayoutBuilder(builder:
              (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              reverse: false,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8.0, left: 8.0, right: 8.0, top: 4.0),
                    child: Visibility(
                      visible: isLoading,
                      child: SpinKitFadingCircle(
                        itemBuilder: (BuildContext context, int index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.green,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Text('Okul Türü'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: DropdownButton<SchoolType>(
                      isExpanded: true,
                      value: selectedSchoolType,
                      icon: const Icon(Icons.arrow_circle_down_sharp),
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (SchoolType? newValue) {
                        setState(() {
                          int? typeId = newValue!.schoolTypeId;
                          if (typeId == 1) {
                            this.isHighSchool = false;
                            this.schoolNameTitle = "Lise Adı";
                          } else if (typeId == 6) {
                            this.isHighSchool = false;
                            this.schoolNameTitle = "Okul Adı";
                          } else if (typeId == 7) {
                            this.isHighSchool = false;
                            this.schoolNameTitle = "İlkokul Adı";
                          } else if (typeId == 12) {
                            this.isHighSchool = false;
                            this.schoolNameTitle = "Ortaokul Adı";
                          } else if (typeId == 13) {
                            this.isHighSchool = false;
                            this.schoolNameTitle = "Meslek Lisesi Adı";
                          } else {
                            this.isHighSchool = true;
                            this.schoolNameTitle = "Üniversite";
                          }
                          selectedSchoolType = newValue;
                          this.memberEducetionModel.schoolTypeId = typeId!;
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
                    child: Text('Eğitim Durumu'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: DropdownButton<EducationStatusModel>(
                      isExpanded: true,
                      value: selectedEducationModel,
                      icon: const Icon(Icons.arrow_circle_down_sharp),
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (EducationStatusModel? newValue) {
                        setState(() {
                          if (newValue!.educationStatusId != 3) {
                            if (newValue.educationStatusId == 2) {
                              this.memberEducetionModel.isLeave = true;
                              this.memberEducetionModel.isResume = false;
                            } else {
                              this.memberEducetionModel.isLeave = false;
                              this.memberEducetionModel.isResume = true;
                            }
                            isFinish = false;
                          } else {
                            isFinish = true;
                          }
                          selectedEducationModel = newValue;
                          this.memberEducetionModel.educationStatusId =
                              newValue.educationStatusId;
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
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Text('Başlama ve Bitiş Tarihi'),
                  ),
                  Table(border: null,
                      // Allows to add a border decoration around your table
                      children: [
                        TableRow(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            child: DropdownButton<SelectYearModel>(
                              isExpanded: true,
                              value: selectedYear,
                              icon: const Icon(Icons.arrow_circle_down_sharp),
                              iconSize: 24,
                              elevation: 16,
                              onChanged: (SelectYearModel? newValue) {
                                setState(() {
                                  selectedYear = newValue!;
                                  this.memberEducetionModel.startDate =
                                      newValue.valueStr.toString();
                                });
                              },
                              items: yearList
                                  .map<DropdownMenuItem<SelectYearModel>>(
                                      (SelectYearModel? value) {
                                return DropdownMenuItem<SelectYearModel>(
                                  value: value,
                                  child: Text(value!.year.toString()),
                                );
                              }).toList(),
                            ),
                          ),
                          Visibility(
                            visible: isFinish,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 16),
                                  child: DropdownButton<SelectYearModel>(
                                    isExpanded: true,
                                    value: selectedFinishYear,
                                    icon: const Icon(
                                        Icons.arrow_circle_down_sharp),
                                    iconSize: 24,
                                    elevation: 16,
                                    onChanged: (SelectYearModel? newValue) {
                                      setState(() {
                                        selectedFinishYear = newValue!;
                                        this.memberEducetionModel.finishDate =
                                            newValue.valueStr.toString();
                                      });
                                    },
                                    items: finishYearList
                                        .map<DropdownMenuItem<SelectYearModel>>(
                                            (SelectYearModel? value) {
                                      return DropdownMenuItem<SelectYearModel>(
                                        value: value,
                                        child: Text(value!.year.toString()),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ]),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8.0, left: 8.0, right: 8.0, top: 4.0),
                    child: Visibility(
                        visible: isFinish,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 16),
                              child: Text('Diploma Not Sistemi'),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 16),
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
                                        .memberEducetionModel
                                        .diplomaGradeSystem = newValue.value;
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
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 16),
                              child: TextField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Diploma Notu"),
                                controller: txtGradle,
                                onChanged: (text) {
                                  this.memberEducetionModel.diplomaGrade = text;
                                },
                              ),
                            ),
                          ],
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: schoolNameTitle),
                      controller: txtSchoolName,
                      onChanged: (text) {
                        this.memberEducetionModel.schoolName = text;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Text('Şehir'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: DropdownButton<CityModel>(
                      isExpanded: true,
                      value: selectedCity,
                      icon: const Icon(Icons.arrow_circle_down_sharp),
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (CityModel? newValue) {
                        setState(() {
                          selectedCity = newValue!;
                          this.memberEducetionModel.cityId = newValue.cityId;
                        });
                      },
                      items: cities
                          .map<DropdownMenuItem<CityModel>>((CityModel? value) {
                        return DropdownMenuItem<CityModel>(
                          value: value,
                          child: Text(value!.cityName.toString()),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8.0, left: 8.0, right: 8.0, top: 4.0),
                    child: Visibility(
                      visible: isHighSchool,
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: "Fakülte"),
                        controller: txtFaculty,
                        onChanged: (text) {
                          this.memberEducetionModel.faculty = text;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8.0, left: 8.0, right: 8.0, top: 4.0),
                    child: Visibility(
                      visible: isHighSchool,
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: "Bölüm"),
                        controller: txtSchoolSection,
                        onChanged: (text) {
                          this.memberEducetionModel.schoolSection = text;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Text('Öğretim Tipi'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: DropdownButton<TeachingTypeModel>(
                      isExpanded: true,
                      value: selectedTeachingModel,
                      icon: const Icon(Icons.arrow_circle_down_sharp),
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (TeachingTypeModel? newValue) {
                        setState(() {
                          selectedTeachingModel = newValue!;
                          this.memberEducetionModel.teachingTypeId =
                              newValue.teachingTypeId;
                        });
                      },
                      items: teachingList
                          .map<DropdownMenuItem<TeachingTypeModel>>(
                              (TeachingTypeModel? value) {
                        return DropdownMenuItem<TeachingTypeModel>(
                          value: value,
                          child: Text(value!.typeName.toString()),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Text('Öğretim Dili'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: DropdownButton<LanguageModel>(
                      isExpanded: true,
                      value: selectedLanguge,
                      icon: const Icon(Icons.arrow_circle_down_sharp),
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (LanguageModel? newValue) {
                        setState(() {
                          selectedLanguge = newValue!;
                          this.memberEducetionModel.languageId =
                              newValue.languageId;
                        });
                      },
                      items: languageList.map<DropdownMenuItem<LanguageModel>>(
                          (LanguageModel? value) {
                        return DropdownMenuItem<LanguageModel>(
                          value: value,
                          child: Text(value!.name.toString()),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Text('Burs'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: DropdownButton<ScholarModel>(
                      isExpanded: true,
                      value: selectedScholar,
                      icon: const Icon(Icons.arrow_circle_down_sharp),
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (ScholarModel? newValue) {
                        setState(() {
                          selectedScholar = newValue!;
                          this.memberEducetionModel.scholarshipTypeId =
                              newValue.scholarshipTypeId;
                        });
                      },
                      items: scholarList.map<DropdownMenuItem<ScholarModel>>(
                          (ScholarModel? value) {
                        return DropdownMenuItem<ScholarModel>(
                          value: value,
                          child: Text(value!.typeName.toString()),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8.0, left: 8.0, right: 8.0, top: 4.0),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: "Açıklama"),
                      controller: txtDescription,
                      onChanged: (text) {
                        this.memberEducetionModel.description = text;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: new RaisedButton(
                        onPressed: () async => {await addEducation()},
                        color: Colors.blue,
                        child: Text('Kaydet'),
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getEducationStatuses();
    getSchoolType();
    getCities();
    getTeachingList();
    getLanguages();
    getScholars();
    for (int i = 1984; i < 2026; i++) {
      SelectYearModel model =
          new SelectYearModel(valueStr: i.toString() + "-01-01", year: i);
      yearList.add(model);
    }
    selectedYear = yearList.where((element) => element.year == 1984).first;
    for (int i = 1984; i < 2026; i++) {
      SelectYearModel model =
          new SelectYearModel(valueStr: i.toString() + "-01-01", year: i);
      finishYearList.add(model);
    }
    selectedFinishYear =
        finishYearList.where((element) => element.year == 1984).first;

    SelectItemModel zeroItem = new SelectItemModel(value: "Seçiniz", id: 0);
    SelectItemModel fourItem = new SelectItemModel(value: "4", id: 4);
    SelectItemModel fiveItem = new SelectItemModel(value: "5", id: 5);
    SelectItemModel tenItem = new SelectItemModel(value: "10", id: 10);
    SelectItemModel hundredItem = new SelectItemModel(value: "100", id: 100);
    gradleSystemList.add(zeroItem);
    gradleSystemList.add(fourItem);
    gradleSystemList.add(fiveItem);
    gradleSystemList.add(tenItem);
    gradleSystemList.add(hundredItem);
    selectedGradleSystem =
        gradleSystemList.where((element) => element.id == 0).first;
    memberEducetionModel.memberEducationId = 0;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
