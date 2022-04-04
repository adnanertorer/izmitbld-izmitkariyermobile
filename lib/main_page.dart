import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izmitbld_kariyer/nav_drawer.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return WillPopScope(
      child: MainWidget(),
      onWillPop: () async => false,
    );
  }
}

class MainWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainWidget();
  }
}

class _MainWidget extends State<MainWidget> {
  var isLoading = false;

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
              padding: const EdgeInsets.only(
                  left: 16.0, top: 50.0, right: 16.0, bottom: 0.0),
              child: new Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines
                children: <Widget>[],
              ),
            )
          ],
        ),
      ),
    );
  }
}
