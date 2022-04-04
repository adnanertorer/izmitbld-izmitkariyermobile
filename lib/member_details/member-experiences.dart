import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:izmitbld_kariyer/login.dart';
import 'package:izmitbld_kariyer/member-add/add-experience.dart';
import 'package:izmitbld_kariyer/member_edit/experience-edit.dart';
import 'package:izmitbld_kariyer/model/member-experience-model.dart';
import 'package:izmitbld_kariyer/tools/SharedPreferencesHelper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';

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

class MemberExperience extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      child: MemberExperienceWidget(),
      onWillPop: () async => false,
    );
  }
}

class MemberExperienceWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MemberExperienceWidget();
  }
}

class _MemberExperienceWidget extends State<MemberExperienceWidget> {
  List<MemberExperienceModel> memberExperienceList = <MemberExperienceModel>[];
  bool isLoading = false;

  Future<void> prepareDelete(int? id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Dikkat"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    "Bu iş deneyiminizi silmek istiyor musunuz? Bu işlemin geri alınamayacağını lütfen göz önünde bulundurun."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yine de sil'),
              onPressed: () async {
                await deleteExperience(id);
              },
            ),
            TextButton(
              child: Text('Vazgeç'),
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

  Future<void> deleteExperience(int? id) async {
    setState(() {
      isLoading = true;
    });
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };

    String apiUrl = SharedPreferencesHelper.getApiAddress() +
        "MemberExperience/Remove/?id=$id";
    var response =
        await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      Map decoded = json.decode(response.body);
      var success = decoded["success"] as bool;
      if (success) {
        setState(() {
          isLoading = false;
        });
        await _showMyDialog(
            "Çalışma deneyimi silindi", "İşlem Başarılı", context);
        Navigator.of(context).pop();
        await getExperiences();
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

  Future<void> getExperiences() async {
    memberExperienceList = <MemberExperienceModel>[];
    setState(() {
      isLoading = true;
    });
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl =
        SharedPreferencesHelper.getApiAddress() + "MemberExperience/List";
    var response =
        await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      Map decoded = json.decode(response.body);
      for (var item in decoded["dynamicClass"]) {
        MemberExperienceModel model = new MemberExperienceModel();
        model.memberExperienceId = item["memberExperienceId"] as int;
        var strStartDate = item["startDate"] as String;
        if (strStartDate.toString().trim().length > 0) {
          var startDate = DateTime.parse(strStartDate);
          model.startDate = startDate.year.toString();
        } else {
          model.startDate = "Belirtilmemiş";
        }

        var strFinishDate = item["finishDate"] as String;
        if (strFinishDate.toString().trim().length > 0) {
          var finishDate = DateTime.parse(strFinishDate);
          model.finishDate = finishDate.year.toString();
        } else {
          model.finishDate = "Belirtilmemiş";
        }

        model.sectorId = item["sectorId"] as int;
        model.position = item["position"] as String;
        model.isWorking = item["isWorking"] as bool;
        model.firmName = item["firmName"] as String;
        model.countryId = item["countryId"] as int;
        model.businessAreaId = item["businessAreaId"] as int;
        model.workingTypeId = item["workingTypeId"] as int;
        if (item["description"] != null) {
          model.description = item["description"] as String;
        } else {
          model.description = "";
        }

        model.cityId = item["cityId"] as int;
        model.memberId = item["memberId"] as int;
        memberExperienceList.add(model);
        print(model.firmName);
      }
      if (memberExperienceList.length > 0) {}
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

  String getIsWorking(bool status) {
    return status == true ? "Evet" : "Hayır";
  }

  String getTimeWork(bool status, int index) {
    return status == false
        ? "<p><b>Başlama Tarihi</b>: " +
            memberExperienceList[index].startDate.toString() +
            "</p><p><b>Bitiş Tarihi:</b> " +
            memberExperienceList[index].finishDate.toString() +
            "</p>" +
            "<p><b>Devam Ediyor musunuz? </b>:" +
            getIsWorking(memberExperienceList[index].isWorking!) +
            "</p>"
        : "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('İş Deneyimlerim'),
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
                        height: double.infinity,
                        width: double.infinity,
                        child: new ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: memberExperienceList.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: EdgeInsets.all(5),
                                  elevation: 20,
                                  color: Colors.white,
                                  child: Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        child: ListTile(
                                          title: Wrap(
                                            crossAxisAlignment: WrapCrossAlignment.center,
                                            children: [
                                              Icon(Icons.account_balance_sharp),
                                              Text(" " +
                                                  memberExperienceList[index]
                                                      .firmName
                                                      .toString())
                                            ],
                                          ),
                                          subtitle: Html(
                                            data: getTimeWork(
                                                memberExperienceList[index].isWorking!,
                                                index),
                                          ),
                                          trailing: GestureDetector(
                                            child: Icon(Icons.delete_forever),
                                            onTap: () async {
                                              await prepareDelete(
                                                  memberExperienceList[index]
                                                      .memberExperienceId);
                                            },
                                          ),
                                        ),
                                        onTap: () => {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ExperienceEdit(
                                                  experienceModel:
                                                      memberExperienceList[index],
                                                ),
                                              ))
                                        },
                                      ),
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
                        onPressed: () async => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddMemberExperience(),
                              ))
                        },
                        color: Colors.blue,
                        child: Text('Ekle'),
                        textColor: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
        ),
    );
  }

  @override
  void initState() {
    super.initState();
    getExperiences();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
