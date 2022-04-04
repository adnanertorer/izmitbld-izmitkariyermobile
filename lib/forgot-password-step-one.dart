import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:izmitbld_kariyer/tools/SharedPreferencesHelper.dart';

import 'model/temp-member-info-model.dart';
import 'nav_drawer.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:convert';

final spinkit = SpinKitFadingCircle(
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: index.isEven ? Colors.red : Colors.green,
      ),
    );
  },
);

class ForgotPasswordStepOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      child: ForgotPasswordStepOneWidget(),
      onWillPop: () async => false,
    );
  }
}

class ForgotPasswordStepOneWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ForgotPasswordStepOneWidget();
  }
}

class _ForgotPasswordStepOneWidget extends State<ForgotPasswordStepOneWidget> {
  TempMemberInfoModel? model = new TempMemberInfoModel();
  final txtTcIdentity = TextEditingController();
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    txtTcIdentity.text = "";
  }

  @override
  void dispose() {
    super.dispose();
  }
  Future<void> send() async{
    if (model!.tcNumber.toString().trim().length > 0 ) {
      setState(() {
        isLoading = true;
      });
      Map<String, String> headers = {'Content-Type': 'application/json'};

      var toJson = model!.toJson();
      var requestJson = convert.jsonEncode(toJson);
      String apiUrl = SharedPreferencesHelper.getApiAddress() + "Member/SendResetSmsCode";
      var response = await http.post(Uri.parse(apiUrl),
          body: requestJson, headers: headers);
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        Map decoded = json.decode(response.body);
        var status = decoded["success"] as bool;
        if(status){
          Navigator.pushNamed(context, '/parola-hatirlat-adim-iki');
        }else{
          await _showMyDialog("Bir sorun oluştu.", "Hata", context);
        }
      } else {
        setState(() {
          isLoading = false;
        });

        await _showMyDialog("Bir sorun oluştu.", "Hata", context);
      }
    } else {
      setState(() {
        isLoading = false;
      });
      await _showMyDialog(
          "Lütfen tüm alanları doldurun", "Eksik Bilgi", context);
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text("Parola Hatırlatma"),
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
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),child:
                Text("Parola sıfırlamak için gerekli kodu sistemde kayıtlı telefon numaranıza "+
                    "sms yoluyla göndereceğiz. Lütfen Tc. Kimlik numaranızı yazınız. Böylelikle size ait kayıtlı numaranızı bulabiliriz."),),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Vatandaşlık Numaranız"),
                    controller: txtTcIdentity,
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onChanged: (text) {
                      this.model!.tcNumber = text;
                    },
                  ),
                ),Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: new RaisedButton(
                      onPressed: () async => {
                        await send()
                      },
                      color: Colors.blue,
                      child: Text('Gönder'),
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
}
