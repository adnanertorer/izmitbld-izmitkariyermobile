import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:izmitbld_kariyer/model/competence-model.dart';
import 'package:izmitbld_kariyer/tools/SharedPreferencesHelper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:convert' as convert;

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

class MemberCompetence extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      child: MemberCompetenceWidget(),
      onWillPop: () async => false,
    );
  }
}

class MemberCompetenceWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MemberCompetenceWidget();
  }
}

class _MemberCompetenceWidget extends State<MemberCompetenceWidget> {
  var txtCompetence = TextEditingController();
  MemberCompetenceModel model = new MemberCompetenceModel();
  List<MemberCompetenceModel> competenceList = <MemberCompetenceModel>[];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    txtCompetence.text = "";
    getCompetence();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> addCompetence() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("İzmit Belediyesi"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Yeni Etkinlik Ekle"),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Yetkinlik"),
                maxLength: 30,
                controller: txtCompetence,
                onChanged: (text) {
                  setState(() {
                    model.competenceName = text;
                  });
                },
              ),
            ),
            TextButton(
              child: Text('Kaydet'),
              onPressed: () async {
                if (model.competenceName != null) {
                  if (model.competenceName!.trim().length > 0) {
                    setState(() {
                      isLoading = true;
                    });
                    model.memberCompetenceId = 0;
                    model.memberId = 0;
                    var token = await SharedPreferencesHelper.getTokenKey();
                    Map<String, String> headers = {
                      'Content-Type': 'application/json',
                      'authorization': 'Bearer $token'
                    };
                    var toJson = model.toJson();
                    var requestJson = convert.jsonEncode(toJson);
                    String apiUrl = SharedPreferencesHelper.getApiAddress() +
                        "MemberCompetence/Add/";
                    var response = await http.post(Uri.parse(apiUrl),
                        body: requestJson, headers: headers);
                    if (response.statusCode == 200) {
                      Map decoded = json.decode(response.body);
                      var status = decoded["success"] as bool;
                      if (status) {
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.of(context).pop();
                        await _showMyDialog(
                            "Yetkinlik eklendi", "İşlem Başarılı", context);
                        await getCompetence();
                        model = new MemberCompetenceModel();
                        txtCompetence.text = "";
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.of(context).pop();
                        model = new MemberCompetenceModel();
                        txtCompetence.text = "";
                        await _showMyDialog(
                            "Bir sorun yaşandı, lütfen tekrar deneyiniz",
                            "İşlem Başarılı",
                            context);
                      }
                    }
                  } else {
                    await _showMyDialog("Lütfen yetkinliğinizi belirtiniz",
                        "Eksik bilgi girişi", context);
                  }
                } else {
                  await _showMyDialog("Lütfen yetkinliğinizi belirtiniz",
                      "Eksik bilgi girişi", context);
                }
              },
            ),
            TextButton(
              child: Text('Vazgeç'),
              onPressed: () {
                setState(() {
                  isLoading = false;
                });
                model.competenceName = "";
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> removeCompetence(int? id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Dikkat"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Bu yetkinlik silinecektir, devam etmek istiyor musunuz?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Evet'),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                var token = await SharedPreferencesHelper.getTokenKey();
                Map<String, String> headers = {
                  'Content-Type': 'application/json',
                  'authorization': 'Bearer $token'
                };
                String apiUrl = SharedPreferencesHelper.getApiAddress() +
                    "MemberCompetence/Remove/?id=" +
                    id.toString();
                var response = await http.post(Uri.parse(apiUrl),
                    body: null, headers: headers);
                if (response.statusCode == 200) {
                  Map decoded = json.decode(response.body);
                  var status = decoded["success"] as bool;
                  if (status) {
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.of(context).pop();
                    await _showMyDialog(
                        "Yetkinlik silindi", "İşlem Başarılı", context);
                    await getCompetence();
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.of(context).pop();
                    await _showMyDialog(
                        "Bir sorun yaşandı, lütfen tekrar deneyiniz",
                        "İşlem Başarılı",
                        context);
                  }
                }
              },
            ),
            TextButton(
              child: Text('Hayır'),
              onPressed: () {
                setState(() {
                  isLoading = false;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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

  Future<void> getCompetence() async {
    competenceList = <MemberCompetenceModel>[];
    setState(() {
      isLoading = true;
    });
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl =
        SharedPreferencesHelper.getApiAddress() + "MemberCompetence/List";
    var response =
        await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      Map decoded = json.decode(response.body);
      for (var item in decoded["dynamicClass"]) {
        MemberCompetenceModel model = new MemberCompetenceModel();
        model.competenceName = item["competenceName"] as String;
        model.memberId = item["memberId"] as int;
        model.memberCompetenceId = item["memberCompetenceId"] as int;
        competenceList.add(model);
      }
      setState(() {
        isLoading = false;
      });
    } else if (response.statusCode == 401) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Yetkinliklerim'),
      ),
      resizeToAvoidBottomInset: false,
      // klavyenin text alanını ezmesini engeller
      body: Center(
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: new ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: competenceList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.all(5),
                          elevation: 20,
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                  title: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Icon(Icons.add_sharp),
                                      Text(" " +
                                          competenceList[index]
                                              .competenceName
                                              .toString())
                                    ],
                                  ),
                                  trailing: GestureDetector(
                                    child: Icon(Icons.delete_forever),
                                    onTap: () async {
                                      await removeCompetence(
                                          competenceList[index]
                                              .memberCompetenceId);
                                    },
                                  )),
                            ],
                          ),
                        );
                      }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: new RaisedButton(
                  onPressed: () async => {await addCompetence()},
                  color: Colors.blue,
                  child: Text('Yeni Ekle'),
                  textColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
