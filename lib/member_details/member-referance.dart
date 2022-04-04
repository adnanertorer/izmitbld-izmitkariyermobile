import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:izmitbld_kariyer/member-add/add-referance.dart';
import 'package:izmitbld_kariyer/member_edit/referance-edit.dart';
import 'package:izmitbld_kariyer/model/member-referance-model.dart';
import 'package:izmitbld_kariyer/tools/SharedPreferencesHelper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';

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
class MemberReferance extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      child: MemberReferanceWidget(),
      onWillPop: () async => false,
    );
  }

}

class MemberReferanceWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MemberReferanceWidget();
  }

}

class _MemberReferanceWidget extends State<MemberReferanceWidget>{

  bool isLoading = false;
  List<MemberReferanceModel> referanceList = <MemberReferanceModel>[];

  Future<void> getReferances() async{
    referanceList = <MemberReferanceModel>[];
    setState(() {
      isLoading = true;
    });
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl =
        SharedPreferencesHelper.getApiAddress() + "MemberReferance/List";
    var response =
    await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      Map decoded = json.decode(response.body);
      for (var item in decoded["dynamicClass"]) {
        MemberReferanceModel model = new MemberReferanceModel();
        model.referanceSurname = item["referanceSurname"] as String;
        model.referancePhone = item["referancePhone"] as String;
        model.referanceName = item["referanceName"] as String;
        model.memberReferanceId = item["memberReferanceId"] as int;
        model.isApprove = item["isApprove"] as int;
        model.memberId = item["memberId"] as int;
        referanceList.add(model);
      }
      setState(() {
        isLoading = false;
      });
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

  Future<void> deleteReferance(int? id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Dikkat"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Bu referans bilgisi kalıcı olarak silinecektir, devam etmek istiyor musunuz?"),
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
                String apiUrl =
                    SharedPreferencesHelper.getApiAddress() + "MemberReferance/Remove/?id="+id.toString();
                var response =
                await http.post(Uri.parse(apiUrl), body: null, headers: headers);
                if (response.statusCode == 200) {
                  Map decoded = json.decode(response.body);
                  var status = decoded["success"] as bool;
                  if(status){
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.of(context).pop();
                    await _showMyDialog("Referasn bilgisi silindi", "İşlem Başarılı", context);
                    await getReferances();
                  }else{
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.of(context).pop();
                    await _showMyDialog("Bir sorun yaşandı, lütfen tekrar deneyiniz", "İşlem Başarısız", context);

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Referanslarım'),
      ),
      resizeToAvoidBottomInset: true,
      // klavyenin text alanını ezmesini engeller
      body: Center(
        child: Column(
          children: <Widget>[
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
            ),Expanded(
              child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: new ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: referanceList.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: EdgeInsets.all(5),
                                elevation: 20,
                                color: Colors.white,
                                child: Column(
                                  children: <Widget>[
                                GestureDetector(
                                child:
                                    ListTile(
                                      title:Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          Icon(Icons.phone),
                                          Text(" "+referanceList[index]
                                              .referanceName
                                              .toString()+" "+referanceList[index]
                                              .referanceSurname
                                              .toString())
                                        ],
                                      ) ,
                                      subtitle:  Html(data: '<p style="color:green;"><b><span style="color:black;">Telefon</span></b>: '+referanceList[index].referancePhone.toString()+'</p>',),
                                      trailing:GestureDetector(
                                        child: Icon(Icons.delete_forever), onTap: () async {
                                        await deleteReferance(referanceList[index].memberReferanceId);
                                      },
                                      ) ,
                                    ),onTap: () => {
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                              builder: (context) => ReferanceEdit(referanceModel: referanceList[index],),
                              ))

                              },),
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
                          builder: (context) => AddReferance(),
                        ))
                  },
                  color: Colors.blue,
                  child: Text('Ekle'),
                  textColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getReferances();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
