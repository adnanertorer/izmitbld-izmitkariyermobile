import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:izmitbld_kariyer/model/gender-model.dart';
import 'package:izmitbld_kariyer/model/member-model.dart';
import 'package:izmitbld_kariyer/model/military-service.dart';
import 'package:izmitbld_kariyer/model/proffession-model.dart';
import 'package:izmitbld_kariyer/model/school-type-model.dart';
import 'package:izmitbld_kariyer/tools/SharedPreferencesHelper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'nav_drawer.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_html/flutter_html.dart';

final spinkit = SpinKitFadingCircle(
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: index.isEven ? Colors.red : Colors.green,
      ),
    );
  },
);

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      child: RegisterWidget(),
      onWillPop: () async => false,
    );
  }
}

class RegisterWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterWidget();
  }
}

class _RegisterWidget extends State<RegisterWidget> {
  var isLoading = false;
  var isVisibleMilitary = false;
  var isPostpone = false;
  final isKeyboard = false;
  String passwordAgain = "";
  GenderModel selectGender = new GenderModel();
  Profession selectedProffessional = new Profession();
  Member member = new Member();

  MilitaryService selectMilitaryService = new MilitaryService();
  SchoolType selectedSchoolType = new SchoolType();
  List<GenderModel> genders = <GenderModel>[];
  List<MilitaryService> militaryServices = <MilitaryService>[];
  List<Profession> profList = <Profession>[];
  List<SchoolType> schoolTypeList = <SchoolType>[];

  Future<List<Profession>> searchProffessions(String val) async {
    return profList
        .where((element) => element.professionName!.contains(val.toString()))
        .toList();
  }

  int? genderValue = 0;
  String militaryService = "Seçiniz";
  var maskFormatter = new MaskTextInputFormatter(
      mask: '##.##.####', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    super.initState();

    member.birthYear = 0;
    member.cityId = 41;
    member.districtId = 477;
    member.email = "";
    member.gender = 0;
    member.graduation = 0;
    member.isActive = true;
    member.militarDelayDate = "";
    member.militaryService = 0;
    member.name = "";
    member.password = "";
    member.phone = "";
    member.profileImage = "";
    member.summaryText = "";
    member.tcIdendtityNumber = "";
    member.vocation = 0;
    member.createdAt = DateTime.now();
    member.memberId = 0;

    member.approvedClarification = false;
    member.approvedKvkk = false;
    member.isActive = true;

    GenderModel menModel = new GenderModel();
    menModel.genderName = 'Erkek';
    menModel.genderId = 2;
    genders.add(menModel);

    GenderModel womenModel = new GenderModel();
    womenModel.genderName = 'Kadın';
    womenModel.genderId = 1;
    genders.add(womenModel);

    GenderModel otherModel = new GenderModel();
    otherModel.genderName = 'Diğer';
    otherModel.genderId = 3;
    genders.add(otherModel);

    GenderModel notShare = new GenderModel();
    notShare.genderName = 'Belirtmek İstemiyorum';
    notShare.genderId = 3;
    genders.add(notShare);

    selectGender.genderName = 'Seçiniz';
    selectGender.genderId = 0;
    genders.add(selectGender);

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

    selectedSchoolType.schoolTypeId = 0;
    selectedSchoolType.typeName = "Seçiniz";

    getProfs();
    getSchoolTypes();
  }

  void registerMember() async {
    if (member.approvedKvkk!) {
      if (member.approvedKvkk == true) {
        print(member.toJson());
        if (member.birthYear != 0 &&
            member.gender != 0 &&
            member.graduation != 0 &&
            member.vocation != 0 &&
            member.email.toString().trim().length > 0 &&
            member.name.toString().trim().length > 0 &&
            member.password.toString().length > 0 &&
            member.phone.toString().length > 0 &&
            member.surname.toString().length > 0 &&
            member.tcIdendtityNumber.toString().length > 0) {
          if (passwordAgain == member.password) {
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

            String apiUrl =
                SharedPreferencesHelper.getApiAddress() + "Member/Register";
            var response = await http.post(Uri.parse(apiUrl),
                body: requestJson, headers: headers);
            if (response.statusCode == 200) {
              Map decoded = json.decode(response.body);
              bool item = decoded["success"] as bool;
              if (item) {
                setState(() {
                  isLoading = false;
                });
                await _showMyDialog("Kayıt başarılı", "Tebrikler", context);
                Navigator.pushNamed(context, '/giris');
              } else {
                await _showMyDialog("Bir sorun oluştu, lütfen tekrar deneyiniz",
                    "Hata", context);
                setState(() {
                  isLoading = false;
                });
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
            await _showMyDialog("Parolalar aynı değil", "Uyuşmazlık", context);
          }
        } else {
          setState(() {
            isLoading = false;
          });
          await _showMyDialog(
              "Lütfen tüm alanları doldurun", "Eksik Bilgi", context);
        }
      }
    } else {
      setState(() {
        isLoading = false;
      });
      await _showMyDialog(
          "Kayıt işleminin tamamlanması için sözleşmeyi kabul etmelisiniz",
          "Dikkat",
          context);
    }
  }

  void getSchoolTypes() async {
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
      schoolTypeList.add(selectedSchoolType);
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

  void getProfs() async {
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
      selectedProffessional.professionName = 'Seçiniz';
      selectedProffessional.professionCode = '';
      selectedProffessional.professionId = -1;
      profList.add(selectedProffessional);
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text('Hesap Oluştur'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, false);
              }),
        ),
        resizeToAvoidBottomInset:
            true, // klavyenin text alanını ezmesini engeller
        body: Center(
          child: LayoutBuilder(builder:
              (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              reverse: false,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Text('Hesap Oluştur'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Adınız',
                      ),
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
                        border: OutlineInputBorder(),
                        hintText: 'Soyadınız',
                      ),
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
                        hintText: 'Tc Kimlik Numaranız',
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 11,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (text) {
                        setState(() {
                          member.tcIdendtityNumber = text;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Doğum Yılınız',
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (text) {
                        setState(() {
                          member.birthYear = int.parse(text);
                        });
                      },
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
                      value: selectGender,
                      icon: const Icon(Icons.arrow_circle_down_sharp),
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (GenderModel? newValue) {
                        if (newValue!.genderId == 2) {
                          setState(() {
                            isVisibleMilitary = true;
                          });
                        } else {
                          setState(() {
                            isVisibleMilitary = false;
                          });
                        }
                        setState(() {
                          selectGender = newValue;
                          member.gender = newValue.genderId;
                        });
                      },
                      items: genders.map<DropdownMenuItem<GenderModel>>(
                          (GenderModel? value) {
                        return DropdownMenuItem<GenderModel>(
                          value: value,
                          child: Text(value!.genderName.toString()),
                        );
                      }).toList(),
                    ),
                  ),
                  Visibility(
                    visible: isVisibleMilitary,
                    child: Column(children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: Text('Askerlik Durumu'),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: DropdownButton<MilitaryService>(
                          isExpanded: true,
                          value: selectMilitaryService,
                          icon: const Icon(Icons.arrow_circle_down_sharp),
                          iconSize: 24,
                          elevation: 16,
                          onChanged: (MilitaryService? newValue) {
                            if (newValue!.id == 1) {
                              setState(() {
                                isPostpone = true;
                              });
                            } else {
                              setState(() {
                                isPostpone = false;
                              });
                            }
                            setState(() {
                              setState(() {
                                selectMilitaryService = newValue;
                                member.militaryService = newValue.id;
                              });
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
                      Visibility(
                        visible: isPostpone,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          child: TextField(
                            inputFormatters: [maskFormatter],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Tecil Tarihi',
                            ),
                            onChanged: (text) {
                              setState(() {
                                member.militarDelayDate = text;
                              });
                            },
                          ),
                        ),
                      ),
                    ]),
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
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'E-Posta Adresiniz',
                      ),
                      keyboardType: TextInputType.emailAddress,
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
                        hintText: 'Telefon Numaranız',
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: (text) {
                        setState(() {
                          member.phone = text;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Parolanız',
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (text) {
                        setState(() {
                          member.password = text;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Tekrar Parolanız',
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (text) {
                        passwordAgain = text;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: new RaisedButton(
                        onPressed: () async =>
                            {_showModalKvkkFromBottom(context)},
                        color: Colors.green,
                        child: Text('Kvkk Aydınlatma Metni'),
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: new RaisedButton(
                        onPressed: () async =>
                            {_showModalClearFromBottom(context)},
                        color: Colors.green,
                        child: Text('Açık Rıza Metni'),
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CheckboxListTile(
                      title: Text(
                          "Verilerimin KVKK aydınlatma metninde belirtildiği şekilde işlenmesine onay veriyorum"),
                      controlAffinity: ListTileControlAffinity.leading,
                      checkColor: Colors.white,
                      value: member.approvedKvkk,
                      shape: CircleBorder(),
                      onChanged: (bool? value) {
                        setState(() {
                          member.approvedKvkk = value!;
                        });
                      },
                    ), //sözleşme alanı
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CheckboxListTile(
                      title: Text("Açık rıza metnini okudum ve kabul ediyorum"),
                      controlAffinity: ListTileControlAffinity.leading,
                      checkColor: Colors.white,
                      value: member.approvedClarification,
                      shape: CircleBorder(),
                      onChanged: (bool? value) {
                        setState(() {
                          member.approvedClarification = value!;
                        });
                      },
                    ), //sözleşme alanı
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: new RaisedButton(
                        onPressed: () async => {registerMember()},
                        color: Colors.blue,
                        child: Text('Kaydet'),
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
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
                ],
              ),
            );
          }),
        ),
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

  void _showModalKvkkFromBottom(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Html(
              data: '<h3 style="text-align:center">6698 SAYILI KİŞİSEL VERİLERİN KORUNMASI KANUNU (“KVKK”) UYARINCA KİŞİSEL VERİLERİN KORUNMASI HAKKINDA' +
                  ' KİŞİSEL VERİNİN İŞLENMESİ VE AKTARILMASI HAKKINDA AÇIK RIZA METNİ </h3><p class="margin-top-10">İzmit Belediyesi (“Belediye”) tarafından, 6698 Sayılı Kişisel Verilerin Korunması Kanunu’nun (“KVKK”) ilgili hükümlerine uygun olarak bilginize sunulan Kişisel Verilerin Korunması ve Gizlilik Politikası ve Kişisel Verilerin İşlenmesine Dair Aydınlatma Metni’nin sınırları çerçevesinde,' +
                  ' Başvurumun istihdam sağlanması amacıyla kendi hazırladığım ve cv’mde yer alan kişisel verilerimin işlenmesini, ilgili süreç kapsamında işlenme amacı ile sınırlı olmak üzere kullanılmasını ve işçi arayan 3.kişilere işe giriş veya mülakata çağrılmam amacıyla, gereken süre zarfında saklanmasını ve bu hususta tarafıma gerekli aydınlatmanın yapıldığını ve Belediye tarafından işlenmesine, muhafaza edilmesine ve aktarılmasına rıza gösterdiğimi beyan ediyorum.' +
                  '</p><p>İşbu açık rıza metnini okudum ve anladım. Yukarıda yer alan hususlara bilerek ve isteyerek rıza gösterdiğimi beyan ederim. Kişisel verilerimin metinde belirtilen şekillerde işlenmesini ve aktarılmasını onaylıyorum ve izin veriyorum.' +
                  '</p>',
            ),
          );
        });
  }

  void _showModalClearFromBottom(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            reverse: false,
            child: Container(
              child: Html(
                data: '<h2 style="text-align:center">T.C.</h2> <h2 style="text-align:center; margin-top:10px;">İZMİT BELEDİYESİ</h2><h2 style="text-align:center; margin-top:10px;">AYDINLATMA METNİ</h2>' +
                    '<p>Değerli Vatandaşlarımız</p>' +
                    '<p style="margin-top:10px;">İzmit Belediyesi olarak kişisel verilerinizin güvenliği hususuna azami hassasiyet göstermekteyiz. Bu bilinçle,' +
                    ' İzmit Belediyesi olarak hizmet faaliyetlerimizden faydalanan vatandaşlarımız dahil, İzmit Belediyesi bünyesinde ilişkili tüm şahıslara ait her türlü kişisel ' +
                    ' verilerin 6698 sayılı Kişisel Verilerin Korunması Kanunu (“Kişisel Verilerin Korunması Kanunu”)’na uygun olarak işlenerek, muhafaza edilmesine büyük önem atfetmekteyiz.' +
                    '  Bu sorumluluğumuzun tam idraki ile Kişisel Verilerin Korunması Kanunu’nda tanımlı şekli ile “Veri Sorumlusu” sıfatıyla,' +
                    ' kişisel verilerinizi aşağıda izah edildiği surette ve mevzuat tarafından emredilen sınırlar çerçevesinde işlemekteyiz.</p>' +
                    '<p style="margin-top:10px;"><span><b>Kişisel Verilerin İşlenme Amaçları </b></span></p>' +
                    '<ul><li>Kurumsal web sitemiz ve e-belediye üzerinden işlem yapanın / yaptıranın kimlik bilgilerini teyit etmek,</li>' +
                    '<li> Kurumsal web sitemiz ve e-belediye üzerinden işlem yapanın / yaptıranın kimlik bilgilerini teyit etmek,</li>' +
                    '<li>Elektronik ortam ve platformlarda (internet/e-belediye vs.) veya kağıt ortamında işleme dayanak olacak tüm kayıt ve belgeleri düzenlemek,</li>' +
                    '<li>Kamu güvenliğine ilişkin hususlarda talep halinde ve mevzuat gereği kamu görevlilerine bilgi verebilmek,</li>' +
                    '<li>' +
                    'Vatandaşlarımızın memnuniyetini artırmak, web sitesi ve/veya e-belediye uygulamalardan işlem yapan vatandaşlarımızı tanıyabilmek ve vatandaş çevresi analizinde' +
                    'kullanabilmek, çeşitli kamusal faaliyetlerinde kullanabilmek ve bu kapsamda anlaşmalı kuruluşlar ' +
                    'aracılığıyla elektronik ortamda ve/veya fiziki ortamda anketler düzenlemek,' +
                    '</li>' +
                    '<li>Vatandaşlarımıza öneri sunabilmek, hizmetlerimizle ilgili vatandaşlarımızı bilgilendirebilmek,</li>' +
                    '<li> Hizmetlerimiz ile ilgili şikayet, istek ve önerilerini değerlendirebilmek,</li>' +
                    '<li>Yasal yükümlülüklerimizi yerine getirebilmek ve yürürlükteki mevzuattan doğan haklarımızı kullanabilmek,</li>' +
                    '</ul>' +
                    '<p style="margin-top:10px;"><span><b>Kişisel Verilerin Toplanma, Saklanma Yöntemi ve Hukuki Sebebi </b></span></p>' +
                    '<p>Kişisel verileriniz 5393 sayılı Belediye Kanunu ve diğer ilgili mevzuatlar uyarınca onay ve/veya imzanızla tanzim edilen belediyecilik işlemlerine' +
                    'ilişkin tüm beyanname/ bilgilendirme formları ve sair belgelerle, elektronik onay ve/veya imzanız ile yapacağınız bildirimlerle, Kurumumuz, yerel hizmet birimleri,' +
                    'Web Sayfaları, Mobil Uygulamalar, Çağrı Merkezi gibi kanallar aracılığı ile sözlü, yazılı veya elektronik ortamda olmak kaydıyla çeşitli yöntemlerle toplanmaktadır.' +
                    ' Belediyemiz tarafından temin edilen ve saklanan kişisel verilerinizin saklandıkları ortamlarda yetkisiz erişime maruz kalmamaları, manipülasyona uğramamaları, ' +
                    ' kaybolmamaları ve zarar görmemeleri amacıyla gereken iş süreçlerinin tasarımı ile teknik güvenlik altyapı geliştirmeleri uygulanmaktadır. Kişisel verileriniz,' +
                    ' size bildirilen amaçlar ve kapsam dışında kullanılmamak kaydı ile gerekli tüm bilgi güvenliği tedbirleri de ' +
                    ' alınarak işlenecek ve yasal saklama süresince veya böyle bir süre öngörülmemişse işleme amacının gerekli kıldığı süre boyunca saklanacak ve işlenecektir.Bu süre sona erdiğinde, kişisel verileriniz silinme, yok edilme ya da anonimleştirme yöntemleri ile Belediyemizin veri akışlarından çıkarılacaktır.' +
                    'Ayrıca Kanunun “Kişisel verilerin işlenme şartları” başlığı altında, ilgili kişinin açık rızası aranmaksızın kişisel verilerinin işlenmesini mümkün kılan şartlar şöyle sıralanmıştır;' +
                    '</p>' +
                    '<ul><li>a) Kanunlarda açıkça öngörülmesi.</li>' +
                    '<li>b) Fiili imkânsızlık nedeniyle rızasını açıklayamayacak durumda bulunan veya rızasına hukuki geçerlilik tanınmayan kişinin kendisinin ya da bir başkasının hayatı veya beden bütünlüğünün korunması için zorunlu olması.' +
                    '</li>' +
                    '<li>c) Bir sözleşmenin kurulması veya ifasıyla doğrudan doğruya ilgili olması kaydıyla, sözleşmenin taraflarına ait kişisel verilerin işlenmesinin gerekli olması.' +
                    '</li>' +
                    '<li>ç) Veri sorumlusunun hukuki yükümlülüğünü yerine getirebilmesi için zorunlu olması.</li>' +
                    '<li>d) İlgili kişinin kendisi tarafından alenileştirilmiş olması.</li>' +
                    '<li> e) Bir hakkın tesisi, kullanılması veya korunması için veri işlemenin zorunlu olması. </li>' +
                    '<li>f) İlgili kişinin temel hak ve özgürlüklerine zarar vermemek kaydıyla, veri sorumlusunun meşru menfaatleri için veri işlenmesinin zorunlu olması' +
                    '</li>' +
                    '</ul>' +
                    '<p style="margin-top:10px;"><span><b>Kişisel Verilerin Aktarılması</b></span></p>' +
                    '<p>Kurumumuz nezdinde bulunan kişisel verileriniz bağlı bulunduğumuz kanun, sair kanun ve sair mevzuat hükümlerinin zorunlu kıldığı/izin verdiği kişi,' +
                    ' kurum ve/veya kuruluşlarla;, vatandaşlara sunulmakta olan hizmetlerin yürütülmesi amacıyla Kocaeli Büyüşehir Belediyesi ile; bağlı bulunan kanunlar kapsamında ' +
                    ' veya İzmit Belediye Meclisinden onay alınmak suretiyle üniversiteler, kamu kurumları ve belediyecilik faaliyetlerimizi yürütmek üzere ' +
                    ' hizmet alınan üçüncü taraflara yasal sınırlamalar çerçevesinde aktarılabilecektir.</p>' +
                    '<p><span><b>Kişisel Verilerin Korunması Kanunu’ndan Doğan Haklar</b></span></p>' +
                    '<p>Belediyemize başvurarak KVKK uyarınca kişisel verilerinizin;</p>' +
                    '<ul>' +
                    '<li>a) Kişisel veri işlenip işlenmediğini öğrenme,</li>' +
                    '<li> b) Kişisel verileri işlenmişse buna ilişkin bilgi talep etme,</li>' +
                    '<li> c) Kişisel verilerin işlenme amacını ve bunların amacına uygun kullanılıp kullanılmadığını öğrenme,</li>' +
                    '<li>d) Yurt içinde veya yurt dışında kişisel verilerin aktarıldığı üçüncü kişileri bilme,</li>' +
                    '<li>e) Kişisel verilerin eksik veya yanlış işlenmiş olması hâlinde bunların düzeltilmesini isteme ve bu kapsamda yapılan' +
                    ' işlemin kişisel verilerin aktarıldığı üçüncü kişilere bildirilmesini isteme,</li>' +
                    '<li>f) KVK Kanunu’nun ve ilgili diğer kanun hükümlerine uygun olarak işlenmiş olmasına rağmen, işlenmesini gerektiren' +
                    ' sebeplerin ortadan kalkması hâlinde kişisel verilerin silinmesini veya yok edilmesini isteme ve bu kapsamda yapılan' +
                    ' işlemin kişisel verilerin aktarıldığı üçüncü kişilere bildirilmesini isteme,</li>' +
                    ' <li> g) İşlenen verilerin münhasıran otomatik sistemler vasıtasıyla analiz edilmesi suretiyle kişinin kendisi aleyhine bir' +
                    'sonucun ortaya çıkmasına itiraz etme,</li>' +
                    '<li> h) Kişisel verilerin kanuna aykırı olarak işlenmesi sebebiyle zarara uğraması hâlinde zararın giderilmesini talep etme' +
                    ' haklarına sahiptir.Bu amaçlarla yaptığınız başvurunun ek bir maliyet gerektirmesi durumunda, Kişisel Verileri Koruma Kurulu tarafından belirlenecek tarifedeki ücret tutarını ödemeniz gerekebilir. Başvurunuzda yer alan talepleriniz, talebin niteliğine göre en kısa sürede ve en geç 30 (otuz) gün içinde sonuçlandırılacaktır.' +
                    '</li>' +
                    '</ul>' +
                    '<p>'
                        'Yukarıda belirtilen haklarınızı kullanmak için kimliğinizi tespit edici gerekli bilgiler ile KVK Kanunu’nun 11. maddesinde belirtilen haklardan kullanmayı talep' +
                    ' ettiğiniz hakkınıza yönelik açıklamalarınızı içeren talebinizi; www.izmit.bel.tr adresindeki formu doldurarak, formun imzalı bir nüshasını ' +
                    ' tespit edici belgeler ile bizzat elden iletebilir, noter kanalıyla veya KVK Kanunu’nda belirtilen diğer yöntemler ile gönderebilir ' +
                    ' veya ilgili formu <b>izmitbelediyesi@hs01.kep.tr</b> KEP adresine güvenli elektronik imzalı olarak iletebilirsiniz. ' +
                    '</p>' +
                    '<h4 style="margin-top:10px;">T.C. İZMİT BELEDİYESİ</h4>' +
                    '<p style="margin-top:10px;">Adres : Ömerağa Mah. Abdurrahman Yüksel Cad. No:9 Belsa Plaza A Blok İzmit/KOCAELİ</p>' +
                    '<p>Telefon: 0 262 318 0000</p>' +
                    '<p>Faks: 0 262 318 0040</p>',
              ),
            ),
          );
        });
  }
}
