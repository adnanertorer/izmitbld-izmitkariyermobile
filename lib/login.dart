import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:izmitbld_kariyer/model/login-model.dart';
import 'package:izmitbld_kariyer/tools/KariyerHelper.dart';
import 'package:izmitbld_kariyer/tools/SharedPreferencesHelper.dart';
import 'dart:convert';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

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

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      child: LoginWidget(),
      onWillPop: () async => false,
    );
  }
}

class LoginWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginWidget();
  }
}

class _LoginWidget extends State<LoginWidget> {
  var isLoading = false;
  LoginResource resource = new LoginResource();

  @override
  void initState() {
    super.initState();
    resource.password = "";
    resource.tcIdendtityNumber = "";
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loginUser() async {
    if (resource.tcIdendtityNumber.toString().trim().length > 0 &&
        resource.password.toString().trim().length > 0) {
      setState(() {
        isLoading = true;
      });
      Map<String, String> headers = {'Content-Type': 'application/json'};

      var toJson = resource.toJson();
      var requestJson = convert.jsonEncode(toJson);
      String apiUrl = SharedPreferencesHelper.getApiAddress() + "Member/Login";
      var response = await http.post(Uri.parse(apiUrl),
          body: requestJson, headers: headers);
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        await parseLogin(response.body);
      } else {
        setState(() {
          isLoading = false;
        });
        await _showMyDialog("Kullanıcı adınız ya da parolanız hatalı olabilir. Lütfen tekrar deneyiniz.", "Hatalı Giriş", context);
      }
    } else {
      setState(() {
        isLoading = false;
      });
      await _showMyDialog(
          "Lütfen tüm alanları doldurun", "Eksik Bilgi", context);
    }
  }

  Future<void> parseLogin(String jsonStr) async {
    setState(() {
      isLoading = true;
    });
    Map decoded = json.decode(jsonStr);
    var status = decoded["success"] as bool;
    if(status){
      var item = decoded["dynamicClass"];
      var token = item["token"].toString();
      var refreshToken = item["refreshToken"].toString();
      var fullName = item["fullName"].toString();
      var endDate = item["expiration"].toString();

      await SharedPreferencesHelper.setTokenKey(token);
      await SharedPreferencesHelper.setRefreshTokenKey(refreshToken);
      await SharedPreferencesHelper.setFullName(fullName);
      await SharedPreferencesHelper.setEndDate(endDate);
      KariyerHelper.isLogin = true;
      setState(() {
        isLoading = false;
      });
      Navigator.pushNamed(context, '/uye-iletisim-bilgileri');
    }else{
      setState(() {
        isLoading = false;
      });
      await _showMyDialog("Kullanıcı adınız ya da parolanız yanlış, lütfen kontrol edip tekrar deneyin.", "Yanlış Bilgi Girişi", context);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Kariyer İzmit'),
      ),
      resizeToAvoidBottomInset:
          true, // klavyenin text alanını ezmesini engeller
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
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
                  padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0, top: 0.0),
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
                        resource.tcIdendtityNumber = text;
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
                        resource.password = text;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: new RaisedButton(
                      onPressed: () async => {await loginUser()},
                      color: Colors.green,
                      child: Text('Giriş Yap'),
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
                          {Navigator.pushNamed(context, '/kayit')},
                      color: Colors.green,
                      child: Text('Kayıt Ol'),
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
                      {Navigator.pushNamed(context, '/parola-hatirlat-adim-bir')},
                      color: Colors.indigo,
                      child: Text('Parolamı Unuttum'),
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ]),
            );
          },
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
}
