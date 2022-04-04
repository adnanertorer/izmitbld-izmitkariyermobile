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

class ForgotPasswordStepTwo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      child: ForgotPasswordStepTwoWidget(),
      onWillPop: () async => false,
    );
  }

}

class ForgotPasswordStepTwoWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ForgotPasswordStepTwoWidget();
  }
}
class _ForgotPasswordStepTwoWidget extends State<ForgotPasswordStepTwoWidget> {
  TempMemberInfoModel? model = new TempMemberInfoModel();
  final txtSmsCode = TextEditingController();
  final txtPassword = TextEditingController();
  final txtPasswordAgain = TextEditingController();
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    txtSmsCode.text = "";
    txtPassword.text = "";
    txtPasswordAgain.text = "";
  }

  @override
  void dispose() {
    super.dispose();
  }
  Future<void> send() async{
    if (model!.password.toString().trim().length > 0 && model!.passwordAgain.toString().trim().length > 0 && model!.smscCode.toString().trim().length > 0) {
      if(model!.password == model!.passwordAgain){
        setState(() {
          isLoading = true;
        });
        Map<String, String> headers = {'Content-Type': 'application/json'};

        var toJson = model!.toJson();
        var requestJson = convert.jsonEncode(toJson);
        String apiUrl = SharedPreferencesHelper.getApiAddress() + "Member/ResetPassword";
        var response = await http.post(Uri.parse(apiUrl),
            body: requestJson, headers: headers);
        if (response.statusCode == 200) {
          setState(() {
            isLoading = false;
          });
          Map decoded = json.decode(response.body);
          var status = decoded["success"] as bool;
          if(status){
            await _showMyDialog("Parolanız sıfırlandı, artık giriş yapabilirsiniz.", "Tebrikler", context);
            Navigator.pushNamed(context, '/giris');
          }else{
            await _showMyDialog("Bir sorun oluştu.", "Hata", context);
          }
        } else {
          setState(() {
            isLoading = false;
          });

          await _showMyDialog("Bir sorun oluştu.", "Hata", context);
        }
      }else{
        await _showMyDialog("Parolalar uyuşmuyor", "Dikkat", context);
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
          title: Text("Parola Sıfırlama"),
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
                        left: 0.0, top: 0.0, right: 0.0, bottom: 0.0),
                    child: new Image(
                      image: AssetImage('assets/images/izmitbld.png'),
                      width: 450,
                      height: 150,
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),child:
                Text("PAROLA SIFIRLAMA", textAlign: TextAlign.center,),),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Size iletilen sms kodu"),
                    controller: txtSmsCode,
                    onChanged: (text) {
                      this.model!.smscCode = text;
                    },
                  ),
                ),Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Parola"),
                    controller: txtPassword,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    onChanged: (text) {
                      this.model!.password = text;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Parola (Tekrar)"),
                    controller: txtPasswordAgain,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    onChanged: (text) {
                      this.model!.passwordAgain = text;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: new RaisedButton(
                      onPressed: () async => {
                        await send()
                      },
                      color: Colors.blue,
                      child: Text('Sıfırla'),
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
