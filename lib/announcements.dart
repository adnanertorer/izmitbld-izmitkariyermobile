import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izmitbld_kariyer/model/v_wanted.dart';
import 'package:izmitbld_kariyer/model/watad-prof.dart';
import 'package:izmitbld_kariyer/tools/SharedPreferencesHelper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:convert' as convert;
import 'model/CategoriesWithCount.dart';
import 'model/v_wantad_prof.dart';
import 'nav_drawer.dart';

class Announcements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      child: AnnouncementWidget(),
      onWillPop: () async => false,
    );
  }
}

class AnnouncementWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AnnouncementWidget();
  }
}

class _AnnouncementWidget extends State<AnnouncementWidget> {
  var listAnnouns = <VWanted>[];
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    controlCategory();
  }

  Future<void> controlCategory() async {
    await SharedPreferencesHelper.getSelectedCategoryId().then((value) => {
          if (value != 0) {getWantedsByCategory(value)} else {getWanteds()}
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void parseForCategory(String jsonStr) {
    Map decoded = json.decode(jsonStr);
    listAnnouns = [];

    for (var item in decoded["dynamicClass"]) {
      var wantAd = new VWanted();
      var profs = item["vWantAdProfsResources"] as List;
      wantAd.workTypeName = item["workTypeName"].toString();
      wantAd.workingTypeId = int.parse(item["workingTypeId"].toString());
      wantAd.nationalityCritId =
          int.parse(item["nationalityCritId"].toString());
      wantAd.natinalityCriteriaName = item["natinalityCriteriaName"].toString();
      wantAd.isEveryProf = item["isEveryProf"] as bool;
      wantAd.isActive = item["isActive"] as bool;
      wantAd.genderCrtId = int.parse(item["genderCrtId"].toString());
      wantAd.genderCriteriaName = item["genderCriteriaName"].toString();
      wantAd.forDisabled = item["forDisabled"] as bool;
      wantAd.forConvict = item["forConvict"] as bool;
      wantAd.educationCrtId = int.parse(item["educationCrtId"].toString());
      wantAd.educationCriteriaName = item["educationCriteriaName"].toString();
      wantAd.description = item["description"].toString();
      wantAd.deadline = item["deadline"].toString();
     /* wantAd.createdById = int.parse(item["createdById"].toString());
      wantAd.changedBySurname = item["changedBySurname"].toString();
      wantAd.changedByName = item["changedByName"].toString();
      wantAd.changedById = int.parse(item["changedById"].toString());
      wantAd.changedAt = item["changedAt"].toString();*/
      wantAd.ageRangeName = item["ageRangeName"].toString();
      wantAd.ageCrtId = int.parse(item["ageCrtId"].toString());
      wantAd.adName = item["adName"].toString();
      wantAd.createdByName = item["createdByName"].toString();
      wantAd.createdBySurname = item["createdBySurname"].toString();
      wantAd.createdAt = item["createdAt"].toString();
      wantAd.categoryId = int.parse(item["categoryId"].toString());
      wantAd.categoryName = item["categoryName"].toString();
      wantAd.wantAdId = int.parse(item["wantAdId"].toString());
      var list =  <VWantAdProf>[];
      var decodedProfs = json.encode(item["vWantAdProfsResources"]);

      var map = json.decode(decodedProfs);

      if (map.length > 0) {
        for(var i = 0; i<map.length; i++){
          VWantAdProf wantAdProf = new VWantAdProf();
          wantAdProf.wantAdId = int.parse(map[i]["wantAdId"].toString());
          wantAdProf.wantAdMainProfId = int.parse(map[i]["wantAdMainProfId"].toString());
          wantAdProf.professionName = map[i]["professionName"].toString();
          wantAdProf.professionCode = map[i]["professionCode"].toString();
          list.add(wantAdProf);
        }
        wantAd.vWantAdProfsResources = list;
        list = <VWantAdProf>[];
      }

      SharedPreferencesHelper.setSelectedCategoryId(0)
          .then((value) => {
      });

      setState(() {
        listAnnouns.add(wantAd);
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void getWanteds() async {
    setState(() {
      isLoading = true;
    });

    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl =
        SharedPreferencesHelper.getApiAddress() + "WantAd/GetAdList";
    var response =
        await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      parseForCategory(response.body);
    } else if (response.statusCode == 401) {
      setState(() {
        isLoading = false;
      });
      //relogin
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void getWantedsByCategory(int categoryId) async {
    setState(() {
      isLoading = true;
    });

    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    var bodyClass = new CategoriesWithCount();
    bodyClass.categoryId = categoryId;
    var toJson = bodyClass.toJson();
    var bodyJson = convert.jsonEncode(toJson);
    String apiUrl =
        SharedPreferencesHelper.getApiAddress() + "WantAd/GetAdListByCategory/?categoryId="+categoryId.toString();
    var response =
        await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      parseForCategory(response.body);
    } else if (response.statusCode == 401) {
      setState(() {
        isLoading = false;
      });
      //relogin
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
    appBar: AppBar(
    title: Text('İlanlar'),
    ),
    resizeToAvoidBottomInset: false,
    body: Center(
    child: Flex(
      direction: Axis.horizontal,
    children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: new ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: listAnnouns.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.all(5),
                      elevation: 20,
                      color: Colors.blue[200],
                      child: Column(children: <Widget>[
                        ListTile(
                          leading: new Image(
                            image: AssetImage('assets/images/izmitbld.png'),
                            width: 50,
                            height: 50,
                          ),
                          title:
                              Text(listAnnouns[index].categoryName.toString()),
                          subtitle: Text(listAnnouns[index].adName.toString()),
                          trailing: GestureDetector(
                                      child: Icon(Icons.announcement_outlined),
                            onTap: ()=>{
                              SharedPreferencesHelper.setSelectedWantAdId(listAnnouns[index].wantAdId).then((value) => {
                                Navigator.pushNamed(
                                    context, '/ilan-detay'),
                              })
                            },
                        ),
                      )]),
                    );
                  },
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
