import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:izmitbld_kariyer/member-add/add-education.dart';
import 'package:izmitbld_kariyer/member_edit/education-edit.dart';
import 'package:izmitbld_kariyer/model/member-education-model.dart';
import 'package:izmitbld_kariyer/model/school-type-model.dart';
import 'package:izmitbld_kariyer/model/teaching-type-model.dart';
import 'package:izmitbld_kariyer/model/v-education-model.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:izmitbld_kariyer/tools/SharedPreferencesHelper.dart';
import 'package:izmitbld_kariyer/tools/api-client.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

class MemberEducation extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      child: MemberEducationWidget(),
      onWillPop: () async => false,
    );
  }
  
}

class MemberEducationWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
      return _MemberEducationWidget();
  }

}

class _MemberEducationWidget extends State<MemberEducationWidget>{

  MemberEducationModel selectedMemberEducetionModel = new MemberEducationModel();
  SchoolType selectedSchoolType = new SchoolType();
  TeachingTypeModel teachingTypeModel = new TeachingTypeModel();
  List<VEducationModel> educationList = <VEducationModel>[];
  List<SchoolType> schoolTypeList = <SchoolType>[];
  bool isLoading = false;
  ApiClient apiClient = new ApiClient();

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


  Future<void> getEducations() async{
    setState(() {
      isLoading = true;
    });
    educationList = <VEducationModel>[];
    educationList = await apiClient.getEducations(context);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteEducation(int? id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Dikkat"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Bu bilgileri silmek istiyor musunuz? Bu işlemin geri alınamayacağını lütfen göz önünde bulundurun."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yine de sil'),
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
                    SharedPreferencesHelper.getApiAddress() + "Education/Remove/?id="+id.toString();
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
                    await _showMyDialog("Eğitim bilgisi silindi", "İşlem Başarılı", context);
                    await getEducations();
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Eğitim Geçmişim'),
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
                              itemCount: educationList.length,
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
                                            Icon(Icons.menu_book),
                                            Text(" "+educationList[index]
                                                .schoolName
                                                .toString())
                                          ],
                                        ) ,
                                        subtitle:  Html(data: '<p style="color:green;"><b><span style="color:black;">Eğitim Durumu</span></b>: '+educationList[index].schoolTypeName.toString()+'</p>',),
                                        trailing:GestureDetector(
                                          child: Icon(Icons.delete_forever), onTap: () async {
                                            await deleteEducation(educationList[index].memberEducationId);
                                        },
                                        ) ,
                                      ),onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EducationEdit(memberEducationModel: educationList[index],),
                                        ))

                                  })
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
                          builder: (context) => AddEducation(),
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
    getEducations();
  }

  @override
  void dispose() {
    super.dispose();
  }
  
}