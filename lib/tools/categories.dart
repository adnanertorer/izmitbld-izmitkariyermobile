import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:izmitbld_kariyer/model/CategoriesWithCount.dart';
import 'package:izmitbld_kariyer/nav_drawer.dart';

import 'SharedPreferencesHelper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

final spinkit = SpinKitFadingCircle(
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: index.isEven ? Colors.red : Colors.green,
      ),
    );
  },
);

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      child: CategoryWidget(),
      onWillPop: () async => false,
    );
  }
}

class CategoryWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CategoryWidget();
  }
}

class _CategoryWidget extends State<CategoryWidget> {
  var listCategory = <CategoriesWithCount>[];
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void parseForCategory(String jsonStr) {
    Map decoded = json.decode(jsonStr);
    listCategory = [];

    // bool successFirst = decoded["success"];
    for (var item in decoded["dynamicClass"]) {
      // print(item["iconName"].toString().replaceAll("assets/", "").replaceAll("/images", "images"));

      var tempCategory = new CategoriesWithCount();
      tempCategory.totalAdByCategory =
          int.parse(item["totalAdByCategory"].toString());
      tempCategory.categoryName = item["categoryName"].toString();
      tempCategory.categoryId = int.parse(item["categoryId"].toString());
      tempCategory.iconName = item["iconName"]
          .toString()
          .replaceAll("/assets", "assets")
          .replaceAll(".svg", ".png")
          .replaceAll("svg/", "");

      setState(() {
        listCategory.add(tempCategory);
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void getCategories() async {
    setState(() {
      isLoading = true;
    });

    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl =
        SharedPreferencesHelper.getApiAddress() + "BasicTypes/GetCategories";
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
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Kariyer İzmit'),
      ),
      resizeToAvoidBottomInset: false,
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
                      itemCount: listCategory.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.all(5),
                          elevation: 20,
                          color: Colors.blue[200],
                          child: Column(children: <Widget>[
                            ListTile(
                              leading: new Image(
                                image: AssetImage(
                                    listCategory[index].iconName.toString()),
                                width: 50,
                                height: 50,
                              ),
                              title:
                                  Text(listCategory[index].categoryName.toString()),
                              subtitle: Text('İlan Sayısı : ' +
                                  listCategory[index].totalAdByCategory.toString()),
                              trailing: GestureDetector(
                                child: Icon(Icons.list),
                                onTap: () => {
                                  if (listCategory[index].categoryId != null)
                                    {
                                      SharedPreferencesHelper.setSelectedCategoryId(
                                              listCategory[index].categoryId)
                                          .then((value) => {
                                                print(value),
                                                Navigator.pushNamed(
                                                    context, '/ilanlar'),
                                              }),
                                    }
                                },
                              ),
                            )
                          ]),
                        );
                      },
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
