import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:izmitbld_kariyer/member_details/member-referance.dart';
import 'package:izmitbld_kariyer/model/member-referance-model.dart';
import 'package:izmitbld_kariyer/tools/SharedPreferencesHelper.dart';
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

class AddReferance extends StatefulWidget{
  @override
  _AddReferanceState createState() => _AddReferanceState();

}
class _AddReferanceState extends State<AddReferance> {
  bool isLoading = false;
  MemberReferanceModel memberReferanceModel = new MemberReferanceModel();
  var txtName = TextEditingController();
  var txtSurname = TextEditingController();
  var txtGsm = TextEditingController();

  Future<void> addReferance() async {
    setState(() {
      isLoading = true;
    });
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    memberReferanceModel.isApprove = 0;
    memberReferanceModel.memberId = 0;
    memberReferanceModel.memberReferanceId = 0;
    var toJson = memberReferanceModel.toJson();
    var requestJson = convert.jsonEncode(toJson);
    String apiUrl = SharedPreferencesHelper.getApiAddress() + "MemberReferance/Add";
    var response =
    await http.post(Uri.parse(apiUrl), body: requestJson, headers: headers);
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      Map decoded = json.decode(response.body);
      var success = decoded["success"] as bool;
      if(success){
        await _showMyDialog("Referans bilgileri eklendi", "İşlem Başarılı", context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MemberReferance(),
            ));
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


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text("Referans Ekle"),
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
              child: Column(children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, top: 0.0, right: 8.0, bottom: 12.0),
                    child: new Image(
                      image: AssetImage('assets/images/izmitlogo.png'),
                      width: 250,
                      height: 120,
                    )),
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
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),child:
                Text("REFERANS BİLGİLERİ", textAlign: TextAlign.center,),),
                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Referans Adı"),
                    controller: txtName,
                    onChanged: (text) {
                      this.memberReferanceModel.referanceName = text;
                    },
                  ),
                ),
                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Referans Soyadı"),
                    controller: txtSurname,
                    onChanged: (text) {
                      this.memberReferanceModel.referanceSurname = text;
                    },
                  ),
                ),
                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Referans Telefon"),
                    controller: txtGsm,
                    onChanged: (text) {
                      this.memberReferanceModel.referancePhone = text;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: new RaisedButton(
                      onPressed: () async => {
                        await addReferance()
                      },
                      color: Colors.blue,
                      child: Text('Kaydet'),
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ]),
            );
          }),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
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
