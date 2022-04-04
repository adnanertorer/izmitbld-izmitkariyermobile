import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:izmitbld_kariyer/member_details/member-experiences.dart';
import 'package:izmitbld_kariyer/model/city-model.dart';
import 'package:izmitbld_kariyer/model/country-model.dart';
import 'package:izmitbld_kariyer/model/member-experience-model.dart';
import 'package:izmitbld_kariyer/model/sector-type-model.dart';
import 'package:izmitbld_kariyer/model/select-year-model.dart';
import 'package:izmitbld_kariyer/model/working-type-model.dart';
import 'package:izmitbld_kariyer/tools/SharedPreferencesHelper.dart';
import 'dart:convert';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:izmitbld_kariyer/tools/api-client.dart';

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

class AddMemberExperience extends StatefulWidget {
  @override
  _AddMemberExperienceState createState() => _AddMemberExperienceState();
}


class _AddMemberExperienceState extends State<AddMemberExperience> {
  MemberExperienceModel model = new MemberExperienceModel();
  ApiClient apiClient = new ApiClient();
  bool isLoading = false;
  bool isShowDates = true;
  final txtFirmName = TextEditingController();
  final txtPosition = TextEditingController();
  final txtStartDate = TextEditingController();
  final txtFinishDate = TextEditingController();
  final txtDescription = TextEditingController();

  List<SelectYearModel> yearList = <SelectYearModel>[];
  List<SelectYearModel> finishYearList = <SelectYearModel>[];
  SelectYearModel selectedYear = new SelectYearModel();
  SelectYearModel selectedFinishYear = new SelectYearModel();

  List<SectorTypeModel> sectorList = <SectorTypeModel>[];
  SectorTypeModel selectedSectorType = new SectorTypeModel();

  List<WorkingTypeModel> workingTypeList = <WorkingTypeModel>[];
  WorkingTypeModel selectedWorkingType = new WorkingTypeModel();

  List<CountryModel> countryList = <CountryModel>[];
  CountryModel selectedCountryModel = new CountryModel();

  List<CityModel> cityList = <CityModel>[];
  CityModel selectedCityModel = new CityModel();


  Future<void> addExperience() async {
    if(this.model.firmName.toString().trim().length > 0 && this.model.position.toString().trim().length > 0
    && this.model.cityId != 0 && this.model.countryId != 0 && this.model.workingTypeId != 0 && this.model.sectorId != 0){
      setState(() {
        isLoading = true;
      });
      var token = await SharedPreferencesHelper.getTokenKey();
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      };


        try{
          if(!isShowDates){
            this.model.startDate = DateTime.now().toIso8601String();
            this.model.finishDate = DateTime.now().toIso8601String();
          }else{
            if(this.model.startDate.toString().trim().length > 0 &&
                this.model.finishDate.toString().trim().length > 0){
              this.model.startDate = DateTime.parse(this.model.startDate.toString()+"-01-01").toIso8601String();
              this.model.finishDate = DateTime.parse(this.model.finishDate.toString()+"-01-01").toIso8601String();
            }else{
              this.model.startDate = DateTime.now().toIso8601String();
              this.model.finishDate = DateTime.now().toIso8601String();
            }
          }
        }catch(ex){
          print(ex);
        }

     if(this.model.isWorking == null){
       this.model.isWorking = false;
     }

     if(this.model.description == null){
       this.model.description = "";
     }

      var toJson = this.model.toJson();
      var requestJson = convert.jsonEncode(toJson);
      String apiUrl = SharedPreferencesHelper.getApiAddress() + "MemberExperience/Add";
      var response =
      await http.post(Uri.parse(apiUrl), body: requestJson, headers: headers);
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        Map decoded = json.decode(response.body);
        var success = decoded["success"] as bool;
        if(success){
          await _showMyDialog("Çalışma deneyimi eklendi", "İşlem Başarılı", context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MemberExperience(),
              ));
        }else{
          setState(() {
            isLoading = false;
          });
          var errorMessage = decoded["message"] as String;
          print(errorMessage);
          await _showMyDialog("Uygulamada bir sorun oluştu, lütfen tekrar deneyiniz", "İşlem Başarısız!", context);
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }else{
      setState(() {
        isLoading = false;
      });
      await _showMyDialog("Lütfen tüm bilgileri doldurun", "Eksik Bilgi", context);
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return  WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text("Deneyim Ekle"),
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
                      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0, top: 4.0),
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
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: "Firma Adı"),
                        controller: txtFirmName,
                        onChanged: (text) {
                          this.model.firmName = text;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: "Pozisyon"),
                        controller: txtPosition,
                        onChanged: (text) {
                          this.model.position = text;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CheckboxListTile(
                        title: Text("Hala çalışıyorum"),
                        controlAffinity: ListTileControlAffinity.leading,
                        checkColor: Colors.white,
                        value: this.model.isWorking != null ? this.model.isWorking : false,
                        shape: CircleBorder(),
                        onChanged: (bool? value) {
                          setState(() {
                            this.model.isWorking = value;
                            setState(() {
                              isShowDates = !value!;
                            });
                          });
                        },
                      ), //sözleşme alanı
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
                            this.model.startDate = newValue.year.toString();
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
                      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0, top: 4.0),
                      child: Visibility(
                        visible: isShowDates,
                        child: Column(
                          children: [
                            Padding(
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
                                    this.model.finishDate = newValue.year.toString();
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
                            ),
                          ],
                        ) ,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: Text('Firma Sektörü'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: DropdownButton<SectorTypeModel>(
                        isExpanded: true,
                        value: selectedSectorType,
                        icon: const Icon(Icons.arrow_circle_down_sharp),
                        iconSize: 24,
                        elevation: 16,
                        onChanged: (SectorTypeModel? newValue) {
                          setState(() {
                            selectedSectorType = newValue!;
                            this.model.sectorId = newValue.sectorTypeId;
                            this.model.businessAreaId = 9;
                          });
                        },
                        items: sectorList.map<DropdownMenuItem<SectorTypeModel>>(
                                (SectorTypeModel? value) {
                              return DropdownMenuItem<SectorTypeModel>(
                                value: value,
                                child: Text(value!.typeName.toString()),
                              );
                            }).toList(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: Text('Çalışma Şekli'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: DropdownButton<WorkingTypeModel>(
                        isExpanded: true,
                        value: selectedWorkingType,
                        icon: const Icon(Icons.arrow_circle_down_sharp),
                        iconSize: 24,
                        elevation: 16,
                        onChanged: (WorkingTypeModel? newValue) {
                          setState(() {
                            selectedWorkingType = newValue!;
                            this.model.workingTypeId = newValue.workingTypeId;
                          });
                        },
                        items: workingTypeList.map<DropdownMenuItem<WorkingTypeModel>>(
                                (WorkingTypeModel? value) {
                              return DropdownMenuItem<WorkingTypeModel>(
                                value: value,
                                child: Text(value!.typeName.toString()),
                              );
                            }).toList(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: Text('Ülke'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: DropdownButton<CountryModel>(
                        isExpanded: true,
                        value: selectedCountryModel,
                        icon: const Icon(Icons.arrow_circle_down_sharp),
                        iconSize: 24,
                        elevation: 16,
                        onChanged: (CountryModel? newValue) {
                          setState(() {
                            selectedCountryModel = newValue!;
                            this.model.countryId = newValue.countryId;
                          });
                        },
                        items: countryList.map<DropdownMenuItem<CountryModel>>(
                                (CountryModel? value) {
                              return DropdownMenuItem<CountryModel>(
                                value: value,
                                child: Text(value!.countryName.toString()),
                              );
                            }).toList(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: Text('İl'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: DropdownButton<CityModel>(
                        isExpanded: true,
                        value: selectedCityModel,
                        icon: const Icon(Icons.arrow_circle_down_sharp),
                        iconSize: 24,
                        elevation: 16,
                        onChanged: (CityModel? newValue) {
                          setState(() {
                            selectedCityModel = newValue!;
                            this.model.cityId = newValue.cityId;
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
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: "İşin Tanımı"),
                        controller: txtDescription,
                        onChanged: (text) {
                          this.model.description = text;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: new RaisedButton(
                          onPressed: () async => {
                            await addExperience()
                          },
                          color: Colors.blue,
                          child: Text('Kaydet'),
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ));
          }),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this.model.memberExperienceId = 0;
    this.model.memberId = 0;
    getSectorTypes();
    for(int i=1984; i<2026;i++){
      SelectYearModel model = new SelectYearModel(valueStr: "01-01-"+i.toString(), year: i);
      yearList.add(model);
    }
    selectedYear = yearList.where((element) => element.year == 1984).first;
    for(int i=1984; i<2026;i++){
      SelectYearModel model = new SelectYearModel(valueStr: "01-01-"+i.toString(), year: i);
      finishYearList.add(model);
    }
    selectedFinishYear = finishYearList.where((element) => element.year == 1984).first;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getSectorTypes() async{
    setState(() {
      isLoading = true;
    });
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl =
        SharedPreferencesHelper.getApiAddress() + "SectorType/List/";
    var response =
    await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      Map decoded = json.decode(response.body);
      for (var item in decoded["dynamicClass"]) {
        SectorTypeModel model = new SectorTypeModel();
        model.typeName = item["typeName"] as String;
        model.sectorTypeId = item["sectorTypeId"] as int;
        sectorList.add(model);
      }
      SectorTypeModel selected_model = new SectorTypeModel();
      selected_model.typeName = "Seçiniz";
      selected_model.sectorTypeId = 0;
      sectorList.add(selected_model);


      selectedSectorType = sectorList.where((element) => element.sectorTypeId == 0).first;

      setState(() {
        isLoading = false;
      });
      getWorkingTypes();
    }else{
      setState(() {
        isLoading = false;
      });
      getWorkingTypes();
    }
  }

  Future<void> getWorkingTypes() async{
    setState(() {
      isLoading = true;
    });
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl =
        SharedPreferencesHelper.getApiAddress() + "WorkingType/List/";
    var response =
    await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      Map decoded = json.decode(response.body);
      for (var item in decoded["dynamicClass"]) {
        WorkingTypeModel model = new WorkingTypeModel();
        model.typeName = item["typeName"] as String;
        model.workingTypeId = item["workingTypeId"] as int;
        workingTypeList.add(model);
      }
      WorkingTypeModel selected_model = new WorkingTypeModel();
      selected_model.typeName = "Seçiniz";
      selected_model.workingTypeId = 0;
      workingTypeList.add(selected_model);

      selectedWorkingType = workingTypeList.where((element) => element.workingTypeId == 0).first;

      setState(() {
        isLoading = false;
      });
      getCountries();
    }else{
      setState(() {
        isLoading = false;
      });
      getCountries();
    }
  }

  Future<void> getCountries() async{
    setState(() {
      isLoading = true;
    });
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl =
        SharedPreferencesHelper.getApiAddress() + "Area/CountryList/";
    var response =
    await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      Map decoded = json.decode(response.body);
      for (var item in decoded["dynamicClass"]) {
        CountryModel model = new CountryModel();
        model.countryName = item["countryName"] as String;
        model.countryId = item["countryId"] as int;
        countryList.add(model);
      }

      CountryModel selected_model = new CountryModel();
      selected_model.countryName = "Seçiniz";
      selected_model.countryId = 0;
      countryList.add(selected_model);

      selectedCountryModel = countryList.where((element) => element.countryId == 0).first;

      setState(() {
        isLoading = false;
      });
      await getCities();
    }else{
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getCities() async{
    setState(() {
      isLoading = true;
    });
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
        cityList.add(model);
      }
      CityModel selected_model = new CityModel();
      selected_model.cityId = 0;
      selected_model.cityName = "Seçiniz";
      cityList.add(selected_model);

      selectedCityModel = cityList.where((element) => element.cityId == 0).first;

      setState(() {
        isLoading = false;
      });
    }else{
      setState(() {
        isLoading = false;
      });
    }
  }
}
