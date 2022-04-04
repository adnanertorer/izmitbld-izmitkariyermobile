import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:izmitbld_kariyer/model/member-want-add-request.dart';
import 'package:izmitbld_kariyer/model/v_wanted.dart';
import 'package:izmitbld_kariyer/tools/SharedPreferencesHelper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;
import 'dart:convert' as convert;

import 'model/v_wantad_prof.dart';
import 'nav_drawer.dart';

final spinkit = SpinKitFadingCircle(
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: index.isEven ? Colors.red : Colors.green,
      ),
    );
  },
);

class AnnouncementDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      child: AnnouncementDetailWidget(),
      onWillPop: () async => false,
    );
  }
}

class AnnouncementDetailWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AnnouncementDetailWidget();
  }
}

class _AnnouncementDetailWidget extends State<AnnouncementDetailWidget> {
  VWanted _wanted = new VWanted();
  var isLoading = false;
  var isVisible = false;
  dom.Document document = htmlparser.parse("<h1></h>");
  var list = <VWantAdProf>[];

  @override
  void initState() {
    super.initState();
    controlId();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> addRequest() async {
    var token = await SharedPreferencesHelper.getTokenKey();
    if (token != null) {
      if (token.trim().toString().length > 0) {
        bool isThereCv = await checkCv(token);
        if (isThereCv) {
          MemberWantAddRequest wantAddRequest = new MemberWantAddRequest();
          wantAddRequest.createdAt = DateTime.now();
          wantAddRequest.wantAdId = _wanted.wantAdId;

          var toJson = wantAddRequest.toJson();

          Map<String, String> headers = {
            'Content-Type': 'application/json',
            'authorization': 'Bearer $token'
          };

          var requestJson = convert.jsonEncode(toJson);

          String apiUrl = SharedPreferencesHelper.getApiAddress() +
              "WantAd/AddWantAdRequest";
          var response = await http.post(Uri.parse(apiUrl),
              body: requestJson, headers: headers);
          if (response.statusCode == 200) {
            Map decoded = json.decode(response.body);
            bool item = decoded["success"] as bool;
            if (item) {
              await _showMyDialog(
                  "Tebrikler, en kısa zamanda sizinle iletişime geçilecektir.",
                  "Tebrikler",
                  context);
            }
          } else if (response.statusCode == 401) {
            setState(() {
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        } else {
          await _showMyDialog(
              "Henüz bir cv oluşturmamışsınız. Bu ilana başvuru yapabilmeniz için cv oluşturmanız gerekmektedir.",
              "Dikkat",
              context);
        }
      } else {
        await _showMyDialog("Bu başvuruya kayıt yapmak için üye olmalısınız.",
            "Üye Giriş/Kayıt", context);
      }
    } else {
      await _showMyDialog("Bu başvuruya kayıt yapmak için üye olmalısınız.",
          "Üye Giriş/Kayıt", context);
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

  void parseWantad(String jsonStr) {
    print(jsonStr);
    Map decoded = json.decode(jsonStr);
    var item = decoded["dynamicClass"];
    var profs = item["vWantAdProfsResources"] as List;
    _wanted.workTypeName = item["workTypeName"].toString();
    _wanted.workingTypeId = int.parse(item["workingTypeId"].toString());
    _wanted.nationalityCritId = int.parse(item["nationalityCritId"].toString());
    _wanted.natinalityCriteriaName = item["natinalityCriteriaName"].toString();
    _wanted.isEveryProf = item["isEveryProf"] as bool;
    _wanted.isActive = item["isActive"] as bool;
    _wanted.genderCrtId = int.parse(item["genderCrtId"].toString());
    _wanted.genderCriteriaName = item["genderCriteriaName"].toString();
    _wanted.forDisabled = item["forDisabled"] as bool;
    _wanted.forConvict = item["forConvict"] as bool;
    _wanted.educationCrtId = int.parse(item["educationCrtId"].toString());
    _wanted.educationCriteriaName = item["educationCriteriaName"].toString();
    _wanted.description = item["description"].toString();
    _wanted.deadline = item["deadline"].toString();
    _wanted.ageRangeName = item["ageRangeName"].toString();
    _wanted.ageCrtId = int.parse(item["ageCrtId"].toString());
    _wanted.adName = item["adName"].toString();
    _wanted.createdByName = item["createdByName"].toString();
    _wanted.createdBySurname = item["createdBySurname"].toString();
    _wanted.createdAt = item["createdAt"].toString();
    _wanted.categoryId = int.parse(item["categoryId"].toString());
    _wanted.categoryName = item["categoryName"].toString();
    _wanted.wantAdId = int.parse(item["wantAdId"].toString());

    document = htmlparser.parse(_wanted.description);

    var decodedProfs = json.encode(item["vWantAdProfsResources"]);
    var map = json.decode(decodedProfs);
    if (map.length > 0) {
      setState(() {
        isVisible = true;
      });
      for (var i = 0; i < map.length; i++) {
        VWantAdProf wantAdProf = new VWantAdProf();
        wantAdProf.wantAdId = int.parse(map[i]["wantAdId"].toString());
        wantAdProf.wantAdMainProfId =
            int.parse(map[i]["wantAdMainProfId"].toString());
        wantAdProf.professionName = map[i]["professionName"].toString();
        wantAdProf.professionCode = map[i]["professionCode"].toString();
        list.add(wantAdProf);
      }
      _wanted.vWantAdProfsResources = list;
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> controlId() async {
    await SharedPreferencesHelper.getSelectedWantAdId().then((value) => {
          if (value != 0) {getWanted(value)}
        });
  }

  void getWanted(int wantedId) async {
    setState(() {
      isLoading = true;
    });

    var token = await SharedPreferencesHelper.getTokenKey();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };

    String apiUrl = SharedPreferencesHelper.getApiAddress() +
        "WantAd/GetById/?id=" +
        wantedId.toString();
    var response =
        await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      parseWantad(response.body);
    } else if (response.statusCode == 401) {
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> checkCv(String token) async {
    setState(() {
      isLoading = true;
    });

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };

    String apiUrl = SharedPreferencesHelper.getApiAddress() + "Member/CheckCv";
    var response =
        await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      Map decoded = json.decode(response.body);
      var item = decoded["dynamicClass"];
      return item["status"] as bool;
    } else if (response.statusCode == 401) {
      setState(() {
        isLoading = false;
      });
      return false;
    } else {
      setState(() {
        isLoading = false;
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text('İlan Detay'),
        ),
        body: Center(
          child: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Html(data: document.outerHtml),
                      Html(
                          data:
                              "<h4>Aday Kriterleri</h4><p><b>Eğitim Seviyesi: </b>" +
                                  _wanted.educationCriteriaName.toString() +
                                  "</p><p><b>Çalışma Sekli: </b>" +
                                  _wanted.workTypeName.toString() +
                                  "</p>"
                                      "<p><b>Yaş Aralığı: </b>" +
                                  _wanted.ageRangeName.toString() +
                                  "</p><p><b>Cinsiyet Kriteri: </b>" +
                                  _wanted.genderCriteriaName.toString() +
                                  "</p>"
                                      "<p><b>Son Başvuru Tarihi: </b>" +
                                  _wanted.deadline.toString() +
                                  "</p>"),
                      Visibility(
                        visible: isVisible,
                        child: Html(data: "<h4>Tercih Edilen Meslekler</h4>"),
                      ),
                      Visibility(
                        visible: isVisible,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: ListView.builder(
                              itemCount: list.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        title: Text(list[index]
                                            .professionName
                                            .toString()),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: new RaisedButton(
                            onPressed: () async => {await addRequest()},
                            color: Colors.blue,
                            child: Text('Başvuru Yap'),
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
                ),
              );
            },
          ),
        ));
  }
}
