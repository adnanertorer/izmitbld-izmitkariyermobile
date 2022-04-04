import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:izmitbld_kariyer/model/driving-licence.dart';
import 'package:izmitbld_kariyer/model/gender-model.dart';
import 'package:izmitbld_kariyer/model/marital-status-model.dart';
import 'package:izmitbld_kariyer/model/military-service.dart';
import 'package:izmitbld_kariyer/model/nationality-model.dart';
import 'package:izmitbld_kariyer/model/personal-information-model.dart';
import 'package:izmitbld_kariyer/tools/SharedPreferencesHelper.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/services.dart';

import '../login.dart';
import '../nav_drawer.dart';
import 'dart:convert';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

final spinkit = SpinKitFadingCircle(
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: index.isEven ? Colors.red : Colors.green,
      ),
    );
  },
);

class PersonelInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      child: PersonelInfoWidget(),
      onWillPop: () async => false,
    );
  }
}

class PersonelInfoWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PersonelInfoWidget();
  }
}

class _PersonelInfoWidget extends State<PersonelInfoWidget> {
  var maskFormatterPhone = new MaskTextInputFormatter(
      mask: '+# (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});
  var maskFormatterBirthDate = new MaskTextInputFormatter(
      mask: '####-##-##', filter: {"#": RegExp(r'[0-9]')});
  PersonelInformationModel personelInformationModel =
      new PersonelInformationModel();
  GenderModel selectedGenderModel = new GenderModel();
  MaritalStatusModel selectedMaritalStatus = new MaritalStatusModel();
  DrivingLicence selectedDriverLicence = new DrivingLicence();
  NationalityModel selectedNationalityModel = new NationalityModel();
  MilitaryService selectMilitaryService = new MilitaryService();
  List<GenderModel> genderList = <GenderModel>[];
  List<MaritalStatusModel> maritalList = <MaritalStatusModel>[];
  List<DrivingLicence> drivingList = <DrivingLicence>[];
  List<NationalityModel> nationalityList = <NationalityModel>[];
  List<MilitaryService> militaryServices = <MilitaryService>[];
  var txtSalaryController = TextEditingController();
  var txtBirthDateController = TextEditingController();
  var txtBirthPlaceController = TextEditingController();
  var txtMilitaryDelayDate = TextEditingController();

  bool isLoading = false;
  bool isDelayMilitary = false;

  @override
  void initState() {
    super.initState();
    selectedGenderModel.genderName = "Seçiniz";
    selectedGenderModel.genderId = 1;
    genderList.add(selectedGenderModel);

    GenderModel womenModel = new GenderModel(genderName: "Kadın", genderId: 1);
    genderList.add(womenModel);

    GenderModel menModel = new GenderModel(genderName: "Erkek", genderId: 2);
    genderList.add(menModel);

    GenderModel otherModel = new GenderModel(genderName: "Diğer", genderId: 3);
    genderList.add(otherModel);

    GenderModel secretModel =
        new GenderModel(genderName: "Belirtmek İstemiyorum", genderId: 4);
    genderList.add(secretModel);

    selectedMaritalStatus.maritalStatusId = 0;
    selectedMaritalStatus.maritalStatus = "Bekar";
    maritalList.add(selectedMaritalStatus);

    MaritalStatusModel marriedStatus =
        new MaritalStatusModel(maritalStatus: "Evli", maritalStatusId: 1);
    maritalList.add(marriedStatus);

    selectMilitaryService.id = 0;
    selectMilitaryService.serviceName = 'Muaf';
    militaryServices.add(selectMilitaryService);

    MilitaryService postPone = new MilitaryService();
    postPone.serviceName = 'Tecilli';
    postPone.id = 1;
    militaryServices.add(postPone);

    MilitaryService done = new MilitaryService();
    done.serviceName = 'Yapıldı';
    done.id = 2;
    militaryServices.add(done);

    MilitaryService currentNow = new MilitaryService();
    currentNow.serviceName = 'Yapılıyor';
    currentNow.id = 3;
    militaryServices.add(currentNow);

    MilitaryService notDone = new MilitaryService();
    notDone.serviceName = 'Yapılmadı';
    notDone.id = 4;
    militaryServices.add(notDone);

    getPersonalDetails();
  }

  Future<void> getPersonalDetails() async {
    setState(() {
      isLoading = true;
    });
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl =
        SharedPreferencesHelper.getApiAddress() + "PersonalInformation/List/";
    var response =
        await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      Map decoded = json.decode(response.body);
      List<PersonelInformationModel> infoList = <PersonelInformationModel>[];
      for (var item in decoded["dynamicClass"]) {
        PersonelInformationModel personelInformationModel =
            new PersonelInformationModel();
        personelInformationModel.drivingLicense =
            int.parse(item["drivingLicense"].toString());
        personelInformationModel.gender = int.parse(item["gender"].toString());
        personelInformationModel.maritalStatus =
            int.parse(item["maritalStatus"].toString());
        personelInformationModel.personalInformationId =
            int.parse(item["personalInformationId"].toString());
        personelInformationModel.nationalityId =
            int.parse(item["nationalityId"].toString());
        personelInformationModel.militarDelayDate =
            item["militarDelayDate"].toString();
        try {
          personelInformationModel.expectationSalary =
              double.parse(item["expectationSalary"].toString());
        } on Exception catch (_) {
          personelInformationModel.expectationSalary = -1;
        }
        personelInformationModel.disabled = item["disabled"] as bool;
        personelInformationModel.birthDate = item["birthDate"].toString();
        personelInformationModel.birthCity = item["birthCity"].toString();
        personelInformationModel.memberId =
            int.parse(item["memberId"].toString());
        personelInformationModel.militaryService =
            int.parse(item["militaryService"].toString());
        //  personelInformationModel.professionId = int.parse(item["professionId"].toString());
        infoList.add(personelInformationModel);
      }

      if (infoList.length > 0) {
        personelInformationModel = infoList[0];
        txtSalaryController.text =
            personelInformationModel.expectationSalary.toString();
        if (personelInformationModel.birthDate != null &&
            personelInformationModel.birthDate.toString().trim().length > 0) {
          DateTime dateBirth =
              DateTime.parse(personelInformationModel.birthDate.toString());
          txtBirthDateController.text = dateBirth.year.toString() +
              '-' +
              dateBirth.month.toString() +
              '-' +
              dateBirth.day.toString();
        }
        txtBirthPlaceController.text =
            personelInformationModel.birthCity.toString();
        if (personelInformationModel.gender != null) {
          if (personelInformationModel.gender != 0) {
            var tempGenderList = genderList
                .where((element) =>
                    personelInformationModel.gender == element.genderId)
                .toList();
            if (tempGenderList.length > 0) {
              selectedGenderModel = tempGenderList.first;
            }
          }
        }
        if (personelInformationModel.maritalStatus != null) {
          var tempMaritalList = maritalList
              .where((element) =>
          personelInformationModel.maritalStatus == element.maritalStatusId)
              .toList();

          if (tempMaritalList.length > 0) {
            selectedMaritalStatus = tempMaritalList.first;
          }
        }
        if (personelInformationModel.militaryService != null) {
          if (personelInformationModel.militaryService != 0) {
            var tempMilitaryServiceList = militaryServices
                .where((element) =>
                    personelInformationModel.militaryService == element.id)
                .toList();
            if (tempMilitaryServiceList.length > 0) {
              selectMilitaryService = tempMilitaryServiceList.first;
            }
          }
        }

        if (personelInformationModel.militaryService == 1) {
          txtMilitaryDelayDate.text =
              personelInformationModel.militarDelayDate.toString();
          isDelayMilitary = true;
        } else {
          isDelayMilitary = false;
        }
      }

      setState(() {
        isLoading = false;
      });
      getDrivingLicences();
    } else if(response.statusCode == 401){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ));
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updatePersonalInfo() async{
    setState(() {
      isLoading = true;
    });
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };

    var toJson = personelInformationModel.toJson();
    var requestJson = convert.jsonEncode(toJson);
    String apiUrl = SharedPreferencesHelper.getApiAddress() + "PersonalInformation/Update";
    var response =
    await http.post(Uri.parse(apiUrl), body: requestJson, headers: headers);
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      Map decoded = json.decode(response.body);
      var success = decoded["success"] as bool;
      if(success){
        await _showMyDialog("Bilgileriniz değiştirildi", "İşlem Başarılı", context);
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

  Future<void> getDrivingLicences() async {
    drivingList = <DrivingLicence>[];
    setState(() {
      isLoading = true;
    });
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl =
        SharedPreferencesHelper.getApiAddress() + "BasicTypes/DriverLicences/";
    var response =
        await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      Map decoded = json.decode(response.body);
      for (var item in decoded["dynamicClass"]) {
        DrivingLicence drivingLicence = new DrivingLicence();
        drivingLicence.driverLicenseId =
            int.parse(item["driverLicenseId"].toString());
        drivingLicence.licenseName = item["licenseName"].toString();
        drivingList.add(drivingLicence);
      }
      selectedDriverLicence.licenseName = "Seçiniz";
      selectedDriverLicence.driverLicenseId = 0;
      drivingList.add(selectedDriverLicence);

      if (personelInformationModel.drivingLicense != null) {
        if (personelInformationModel.drivingLicense != 0) {
          var tempLicenceList = drivingList
              .where((element) =>
                  personelInformationModel.drivingLicense ==
                  element.driverLicenseId)
              .toList();
          if (tempLicenceList.length > 0) {
            selectedDriverLicence = tempLicenceList.first;
          }
        }
      }
      setState(() {
        isLoading = false;
      });

      await getNationalities();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getNationalities() async {
    nationalityList = <NationalityModel>[];
    setState(() {
      isLoading = true;
    });
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl =
        SharedPreferencesHelper.getApiAddress() + "BasicTypes/NationalityList/";
    var response =
        await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      Map decoded = json.decode(response.body);
      for (var item in decoded["dynamicClass"]) {
        NationalityModel nationalityModel = new NationalityModel();
        nationalityModel.nationalityTypeId =
            int.parse(item["nationalityTypeId"].toString());
        nationalityModel.typeName = item["typeName"].toString();
        nationalityList.add(nationalityModel);
      }
      selectedNationalityModel.typeName = "Seçiniz";
      selectedNationalityModel.nationalityTypeId = 0;
      nationalityList.add(selectedNationalityModel);

      if (personelInformationModel.nationalityId != null) {
        if (personelInformationModel.nationalityId != 0) {
          var tempnationalityList = nationalityList
              .where((element) =>
                  personelInformationModel.nationalityId ==
                  element.nationalityTypeId)
              .toList();
          if (tempnationalityList.length > 0) {
            selectedNationalityModel = tempnationalityList.first;
          }
        }
      }
      setState(() {
        isLoading = false;
      });
    }else if(response.statusCode == 401){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ));
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Kişisel Bilgiler'),
      ),
      resizeToAvoidBottomInset: true,
      // klavyenin text alanını ezmesini engeller
      body: Center(
        child: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            reverse: false,
            child: Column(children: <Widget>[
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
                child: Text('Cinsiyet'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: DropdownButton<GenderModel>(
                  isExpanded: true,
                  value: selectedGenderModel,
                  icon: const Icon(Icons.arrow_circle_down_sharp),
                  iconSize: 24,
                  elevation: 16,
                  onChanged: (GenderModel? newValue) async {
                    setState(() {
                      selectedGenderModel = newValue!;
                      personelInformationModel.gender = newValue.genderId;
                    });
                  },
                  items: genderList
                      .map<DropdownMenuItem<GenderModel>>((GenderModel? value) {
                    return DropdownMenuItem<GenderModel>(
                      value: value,
                      child: Text(value!.genderName.toString()),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Text('Medeni Durum'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: DropdownButton<MaritalStatusModel>(
                  isExpanded: true,
                  value: selectedMaritalStatus,
                  icon: const Icon(Icons.arrow_circle_down_sharp),
                  iconSize: 24,
                  elevation: 16,
                  onChanged: (MaritalStatusModel? newValue) async {
                    setState(() {
                      selectedMaritalStatus = newValue!;
                      personelInformationModel.maritalStatus =
                          newValue.maritalStatusId;
                    });
                  },
                  items: maritalList.map<DropdownMenuItem<MaritalStatusModel>>(
                      (MaritalStatusModel? value) {
                    return DropdownMenuItem<MaritalStatusModel>(
                      value: value,
                      child: Text(value!.maritalStatus.toString()),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Text('Sürücü Belgesi'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: DropdownButton<DrivingLicence>(
                  isExpanded: true,
                  value: selectedDriverLicence,
                  icon: const Icon(Icons.arrow_circle_down_sharp),
                  iconSize: 24,
                  elevation: 16,
                  onChanged: (DrivingLicence? newValue) async {
                    setState(() {
                      selectedDriverLicence = newValue!;
                      personelInformationModel.drivingLicense =
                          newValue.driverLicenseId;
                    });
                  },
                  items: drivingList.map<DropdownMenuItem<DrivingLicence>>(
                      (DrivingLicence? value) {
                    return DropdownMenuItem<DrivingLicence>(
                      value: value,
                      child: Text(value!.licenseName.toString()),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Text('Uyruk'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: DropdownButton<NationalityModel>(
                  isExpanded: true,
                  value: selectedNationalityModel,
                  icon: const Icon(Icons.arrow_circle_down_sharp),
                  iconSize: 24,
                  elevation: 16,
                  onChanged: (NationalityModel? newValue) async {
                    setState(() {
                      selectedNationalityModel = newValue!;
                      personelInformationModel.nationalityId =
                          newValue.nationalityTypeId;
                    });
                  },
                  items: nationalityList
                      .map<DropdownMenuItem<NationalityModel>>(
                          (NationalityModel? value) {
                    return DropdownMenuItem<NationalityModel>(
                      value: value,
                      child: Text(value!.typeName.toString()),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Maaş Beklentisi"),
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true, signed: false),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'^(\d+)?\,?\d{0,2}')),
                  ],
                  controller: txtSalaryController,
                  onChanged: (text) {
                    setState(() {
                      personelInformationModel.expectationSalary =
                          double.parse(text);
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Doğum Tarihi (Yıl-Ay-Gün)"),
                  maxLength: 10,
                  inputFormatters: [maskFormatterBirthDate],
                  controller: txtBirthDateController,
                  onChanged: (text) {
                    setState(() {
                      personelInformationModel.birthDate = text;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Doğum Yeri"),
                  controller: txtBirthPlaceController,
                  onChanged: (text) {
                    setState(() {
                      personelInformationModel.birthCity = text;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Text('Askerlik Durumu'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: DropdownButton<MilitaryService>(
                  isExpanded: true,
                  value: selectMilitaryService,
                  icon: const Icon(Icons.arrow_circle_down_sharp),
                  iconSize: 24,
                  elevation: 16,
                  onChanged: (MilitaryService? newValue) async {
                    setState(() {
                      if (newValue?.id == 1) {
                        isDelayMilitary = true;
                      } else {
                        isDelayMilitary = false;
                      }
                      selectMilitaryService = newValue!;
                      personelInformationModel.militaryService = newValue.id;
                    });
                  },
                  items: militaryServices
                      .map<DropdownMenuItem<MilitaryService>>(
                          (MilitaryService? value) {
                    return DropdownMenuItem<MilitaryService>(
                      value: value,
                      child: Text(value!.serviceName.toString()),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Visibility(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Tecil Tarihi"),
                        controller: txtMilitaryDelayDate,
                        onChanged: (text) {
                          setState(() {
                            personelInformationModel.militarDelayDate = text;
                          });
                        },
                      ),
                    ),
                    visible: isDelayMilitary,
                  )),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CheckboxListTile(
                  title: Text(
                      "Engelliyseniz lütfen bunu belirtin. Böylece size sağlanan ayrıcalıklı istihdam olanaklarından faydalanabilirsiniz."),
                  controlAffinity: ListTileControlAffinity.leading,
                  checkColor: Colors.white,
                  value: personelInformationModel.disabled != null ? personelInformationModel.disabled : false,
                  shape: CircleBorder(),
                  onChanged: (bool? value) {
                    setState(() {
                      personelInformationModel.disabled = value!;
                    });
                  },
                ), //sözleşme alanı
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: new RaisedButton(
                    onPressed: () async => {
                      await updatePersonalInfo()
                    },
                    color: Colors.blue,
                    child: Text('Güncelle'),
                    textColor: Colors.white,
                  ),
                ),
              ),
            ]),
          );
        }),
      ),
    );
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
}
