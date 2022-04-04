import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:izmitbld_kariyer/member_edit/member-document-add.dart';
import 'package:izmitbld_kariyer/model/v-member-documents.dart';
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

class MemberDocument extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      child: MemberDocumentWidget(),
      onWillPop: () async => false,
    );
  }

}

class MemberDocumentWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MemberDocumentWidget();
  }

}

class _MemberDocumentWidget extends State<MemberDocumentWidget>{
  List<VMemberDocuments> documentList =<VMemberDocuments>[];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getDocuments();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> deleteDocument(int? id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Dikkat"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Bu belge kalıcı olarak silinecektir, devam etmek istiyor musunuz?"),
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
                    SharedPreferencesHelper.getApiAddress() + "MemberDocument/Remove/?id="+id.toString();
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
                    await _showMyDialog("Belge silindi", "İşlem Başarılı", context);
                    await getDocuments();
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

  Future<void> getDocuments() async{
    documentList = <VMemberDocuments>[];
    setState(() {
      isLoading = true;
    });
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl =
        SharedPreferencesHelper.getApiAddress() + "MemberDocument/List";
    var response =
    await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      Map decoded = json.decode(response.body);
      for (var item in decoded["dynamicClass"]) {
        VMemberDocuments model = new VMemberDocuments();
        model.documentTypeName = item["documentTypeName"] as String;
        model.documentTypeId = item["documentTypeId"] as int;
        model.documentFilePatch = item["documentFilePatch"] as String;
        model.documentFileName = item["documentFileName"] as String;
        model.memberId = item["memberId"] as int;
        model.memberDocumentId = item["memberDocumentId"] as int;
        documentList.add(model);
      }
      setState(() {
        isLoading = false;
      });
    }  else if(response.statusCode == 401){
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
        title: Text('Belgelerim'),
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
                        width: double.infinity,
                        height: double.infinity,
                        child: new ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: documentList.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: EdgeInsets.all(5),
                                elevation: 20,
                                color: Colors.white,
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      title:Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          Icon(Icons.all_inbox),
                                          Text(" "+documentList[index]
                                              .documentTypeName
                                              .toString())
                                        ],
                                      ) ,
                                      subtitle:  Html(data: '<p style="color:green;"><b><span style="color:black;">Belge Adı</span></b>: '+documentList[index].documentFileName.toString()+'</p>',),
                                      trailing:GestureDetector(
                                        child: Icon(Icons.delete_forever), onTap: () async {
                                             await deleteDocument(documentList[index].memberDocumentId);
                                      },
                                      ) ,
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
                          builder: (context) => MemberDocumentAdd(),
                        ))
                  },
                  color: Colors.blue,
                  child: Text('Yeni Belge Ekle'),
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