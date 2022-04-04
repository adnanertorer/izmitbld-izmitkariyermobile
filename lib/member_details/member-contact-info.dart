import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:izmitbld_kariyer/model/city-model.dart';
import 'package:izmitbld_kariyer/model/district-model.dart';
import 'package:izmitbld_kariyer/model/member-model.dart';
import 'package:izmitbld_kariyer/model/proffession-model.dart';
import 'package:izmitbld_kariyer/model/school-type-model.dart';
import 'package:izmitbld_kariyer/tools/SharedPreferencesHelper.dart';
import 'dart:convert';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../login.dart';
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

class MemberContactInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      child: MemberConcactInfoWidget(),
      onWillPop: () async => false,
    );
  }
}

class MemberConcactInfoWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MemberConcactInfoWidget();
  }
}

class _MemberConcactInfoWidget extends State<MemberConcactInfoWidget> {
  var isLoading = false;
  Member member = new Member();
  var txtNameController = TextEditingController();
  var txtSurNameController = TextEditingController();
  var txtEmailController = TextEditingController();
  var txtPhoneController = TextEditingController();
  List<CityModel> cities = <CityModel>[];
  List<DistrictModel> districts = <DistrictModel>[];
  List<Profession> profList = <Profession>[];
  List<SchoolType> schoolTypeList = <SchoolType>[];

  CityModel selectedCity = new CityModel();
  DistrictModel selectedDistrict = new DistrictModel();
  Profession selectedProffessional = new Profession();
  SchoolType selectedSchoolType = new SchoolType();

  Future<List<Profession>> searchProffessions(String val) async {
    return profList
        .where((element) => element.professionName!.contains(val.toString()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    getMemberDetail();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getSchoolTypes() async {
    setState(() {
      isLoading = true;
    });

    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl = SharedPreferencesHelper.getApiAddress() + "SchoolType/List";

    var response =
    await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      Map decoded = json.decode(response.body);
      for (var item in decoded["dynamicClass"]) {
        SchoolType schoolType = new SchoolType();
        schoolType.schoolTypeId = item["schoolTypeId"] as int;
        schoolType.typeName = item["typeName"] as String;
        schoolTypeList.add(schoolType);
      }
      if(member.graduation == 0) {
        selectedSchoolType.typeName = 'Seçiniz';
        selectedSchoolType.schoolTypeId = 0;
        schoolTypeList.add(selectedSchoolType);
      }else{
        selectedSchoolType = schoolTypeList.where((element) => member.graduation == element.schoolTypeId).toList().first;
      }

      setState(() {
        isLoading = false;
      });
    } else if (response.statusCode == 401) {
      setState(() {
        isLoading = false;
      });
      //relogin
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getProfs() async {
    setState(() {
      isLoading = true;
    });

    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl = SharedPreferencesHelper.getApiAddress() + "WantAd/ProfList";
    var response =
    await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      Map decoded = json.decode(response.body);
      for (var item in decoded["dynamicClass"]) {
        Profession profession = new Profession();
        profession.professionId = item["professionId"] as int;
        profession.professionCode = item["professionCode"] as String;
        profession.professionName = item["professionName"] as String;
        profList.add(profession);
      }
      if(member.vocation == 0) {
        selectedProffessional.professionName = 'Seçiniz';
        selectedProffessional.professionCode = '';
        selectedProffessional.professionId = -1;
      }else{
        selectedProffessional = profList.where((element) => member.vocation == element.professionId).toList().first;
      }
      profList.add(selectedProffessional);
      setState(() {
        isLoading = false;
      });
      await getSchoolTypes();
    } else if (response.statusCode == 401) {
      setState(() {
        isLoading = false;
      });
      //relogin
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateMemberDetail() async {
    setState(() {
      isLoading = true;
    });
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    var toJson = member.toJson();
    var requestJson = convert.jsonEncode(toJson);
    String apiUrl = SharedPreferencesHelper.getApiAddress() + "Member/UpdateMember";
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

  Future<void> parseMemberDetail(String responseBody) async {
    setState(() {
      isLoading = true;
    });
    Map decoded = json.decode(responseBody);
    var item = decoded["dynamicClass"];

    txtNameController.text = item["name"].toString();
    txtSurNameController.text = item["surname"].toString();
    txtEmailController.text = item["email"].toString();
    txtPhoneController.text = item["phone"].toString();
    member.cityId = int.parse(item["cityId"].toString());
    member.cityName = item["cityName"].toString();
    member.districtId = int.parse(item["districtId"].toString());
    member.districtName = item["districtName"].toString();
    member.vocation = int.parse(item["vocationId"].toString());
    member.graduation = int.parse(item["graduationId"].toString());
    member.memberId = int.parse(item["memberId"].toString());
    member.isActive = item["isActive"] as bool;
    member.email = item["email"].toString();
    member.phone = item["phone"].toString();
    member.surname = item["surname"].toString();
    member.name = item["name"].toString();
    member.vocation = int.parse(item["vocationId"].toString());
    member.tcIdendtityNumber = item["tcIdendtityNumber"].toString();
    setState(() {
      isLoading = false;
    });

    await getCities();
  }

  void getMemberDetail() async {
    setState(() {
      isLoading = true;
    });
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl =
        SharedPreferencesHelper.getApiAddress() + "Member/VMemberDetail";
    var response =
        await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      await parseMemberDetail(response.body);
    } else if(response.statusCode == 401){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ));
    }  else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getCities() async {
    cities = <CityModel>[];
    setState(() {
      isLoading = true;
    });
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl = SharedPreferencesHelper.getApiAddress() + "Area/CityList";
    var response =
        await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      Map decoded = json.decode(response.body);
      for (var item in decoded["dynamicClass"]) {
        CityModel cityModel = new CityModel();
        cityModel.cityId = int.parse(item["cityId"].toString());
        cityModel.cityName = item["cityName"].toString();
        cities.add(cityModel);
      }
      if(member.cityId == 0) {
        selectedCity.cityName = "Seçiniz";
        selectedCity.cityId = 0;
      }else{
        selectedCity = cities.where((element) => member.cityId == element.cityId).toList().first;
        await getDistricts(selectedCity.cityId);
      }
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getDistricts(int? cityId) async {
    districts = <DistrictModel>[];
    setState(() {
      isLoading = true;
    });
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl = SharedPreferencesHelper.getApiAddress() + "Area/DistrictList/?cityId="+cityId.toString();
    var response =
    await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      Map decoded = json.decode(response.body);
      for (var item in decoded["dynamicClass"]) {
        DistrictModel districtModel = new DistrictModel();
        districtModel.districtId = int.parse(item["districtId"].toString());
        districtModel.cityId = int.parse(item["cityId"].toString());
        districtModel.districtName = item["districtName"].toString();
        districts.add(districtModel);
      }
      selectedDistrict.districtName = "Seçiniz";
      selectedDistrict.cityId = 0;
      selectedDistrict.districtId = 0;
      districts.add(selectedDistrict);

      if(member.districtId != null) {
        if(member.districtId != 0) {
          var tempDistrictList = districts.where((element) => member.districtId == element.districtId).toList();
          if(tempDistrictList.length > 0){
            selectedDistrict = tempDistrictList.first;
          }
        }
      }
      setState(() {
        isLoading = false;
      });
      await getProfs();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Genel Bilgiler'),
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
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Adınız"),
                    controller: txtNameController,
                    onChanged: (text) {
                      setState(() {
                        member.name = text;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Soyadınız"),
                    controller: txtSurNameController,
                    onChanged: (text) {
                      setState(() {
                        member.surname = text;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "E-Posta Adresiniz"),
                    controller: txtEmailController,
                    onChanged: (text) {
                      setState(() {
                        member.email = text;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Telefon Numaranız"),
                    controller: txtPhoneController,
                    onChanged: (text) {
                      setState(() {
                        member.phone = text;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Text('Yaşadığınız İl')  ,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: DropdownButton<CityModel>(
                    isExpanded: true,
                    value: selectedCity,
                    icon: const Icon(Icons.arrow_circle_down_sharp),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (CityModel? newValue) async {
                      setState(() {
                        selectedCity = newValue!;
                        member.cityId = newValue.cityId;
                      });
                      await getDistricts(selectedCity.cityId);
                    },
                    items: cities.map<DropdownMenuItem<CityModel>>(
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
                  child: Text('Yaşadığınız İlçe'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: DropdownButton<DistrictModel>(
                    isExpanded: true,
                    value: selectedDistrict,
                    icon: const Icon(Icons.arrow_circle_down_sharp),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (DistrictModel? newValue) async {
                      setState(() {
                        selectedDistrict = newValue!;
                        member.districtId = newValue.districtId;
                      });
                    },
                    items: districts.map<DropdownMenuItem<DistrictModel>>(
                            (DistrictModel? value) {
                          return DropdownMenuItem<DistrictModel>(
                            value: value,
                            child: Text(value!.districtName.toString()),
                          );
                        }).toList(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Text('Mesleğiniz ya da Uzmanlık Alanınız'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: DropdownSearch<Profession>(
                    searchFieldProps: TextFieldProps(
                      controller: TextEditingController(text: ''),
                    ),
                    mode: Mode.BOTTOM_SHEET,
                    maxHeight: 700,
                    isFilteredOnline: true,
                    showClearButton: true,
                    onFind: (String filter) => searchProffessions(filter),
                    onChanged: (Profession? newValue) {
                      setState(() {
                        selectedProffessional = newValue!;
                        member.vocation = newValue.professionId;
                      });
                    },
                    selectedItem: selectedProffessional,
                    dropdownSearchDecoration: InputDecoration(
                      filled: true,
                      fillColor:
                      Theme.of(context).inputDecorationTheme.fillColor,
                    ),
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    compareFn: (item, selectedItem) =>
                    item.professionId == selectedItem?.professionId,
                    showSearchBox: true,
                    label: "Meslekler",
                    hint: "Arama yapabilirsiniz", //searchProffessions

                    itemAsString: (Profession u) =>
                        u.professionName!.toString(),

                    items: profList,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Text('Eğitim Durumunuz'),
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
                        selectedSchoolType = newValue!;
                        member.graduation = newValue.schoolTypeId;
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
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: new RaisedButton(
                      onPressed: () async => {
                        await updateMemberDetail()
                      },
                      color: Colors.blue,
                      child: Text('Güncelle'),
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ]));
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
