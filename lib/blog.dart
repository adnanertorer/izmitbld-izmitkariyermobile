import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:izmitbld_kariyer/model/blog-model.dart';
import 'package:izmitbld_kariyer/tools/SharedPreferencesHelper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

class Blog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      child: BlogWidget(),
      onWillPop: () async => false,
    );
  }
}

class BlogWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BlogWidget();
  }
}

class _BlogWidget extends State<BlogWidget> {
  bool isLoading = false;
  List<BlogModel>? blogList = <BlogModel>[];

  Future<void> getBlogs() async {
    blogList = <BlogModel>[];
    setState(() {
      isLoading = true;
    });
    var token = await SharedPreferencesHelper.getTokenKey();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    };
    String apiUrl = SharedPreferencesHelper.getApiAddress() + "Blog/ActiveList";
    var response =
        await http.post(Uri.parse(apiUrl), body: null, headers: headers);
    if (response.statusCode == 200) {
      Map decoded = json.decode(response.body);
      for (var item in decoded["dynamicClass"]) {
        BlogModel model = new BlogModel();
        model.id = item["id"] as int;
        model.blogText = item["blogText"] as String;
        model.blogImage = item["blogImage"] as String;
        model.description = item["description"] as String;
        model.title = item["title"] as String;
        blogList!.add(model);
      }
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getBlogs();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Scaffold(
          drawer: NavDrawer(),
          appBar: AppBar(
            title: Text("Blog"),
          ),
          resizeToAvoidBottomInset: true,
          // klavyenin text alanını ezmesini engeller
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
                            itemCount: blogList!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 8.0,
                                          left: 8.0,
                                          right: 8.0,
                                          top: 4.0),
                                      child: Visibility(
                                        visible: isLoading,
                                        child: SpinKitFadingCircle(
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                            return DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(blogList![index].title.toString(),
                                          style: TextStyle(
                                              color: Colors.black.withOpacity(0.6)),
                                          textAlign: TextAlign.center),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        blogList![index].blogText.toString(),
                                        style: TextStyle(
                                            color: Colors.black.withOpacity(0.6)),
                                      ),
                                    ),
                                    Image.network(
                                        'https://careerapi.izmit.bel.tr/blog_images/' +
                                            blogList![index].blogImage.toString())
                                  ],
                                ),
                              );
                            })),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
