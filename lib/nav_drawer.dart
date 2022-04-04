import 'package:flutter/material.dart';
import 'package:izmitbld_kariyer/announcements.dart';
import 'package:izmitbld_kariyer/blog.dart';
import 'package:izmitbld_kariyer/login.dart';
import 'package:izmitbld_kariyer/member_details/member-competence.dart';
import 'package:izmitbld_kariyer/member_details/member-contact-info.dart';
import 'package:izmitbld_kariyer/member_details/member-experiences.dart';
import 'package:izmitbld_kariyer/member_details/member-referance.dart';
import 'package:izmitbld_kariyer/member_details/personal-info.dart';
import 'package:izmitbld_kariyer/tools/KariyerHelper.dart';
import 'package:izmitbld_kariyer/tools/categories.dart';

import 'member_details/member-document.dart';
import 'member_details/member-education.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  //width: MediaQuery.of(context).size.width * 0.45,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/izmitlogo.png"),
                            fit: BoxFit.scaleDown,
                            scale: 3.5)),
                    child: Text(""),
                  ),
                ),
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.art_track_sharp),
            title: Text('Blog'),
            onTap: () => {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Blog()),
                  ModalRoute.withName("/blog"))
            },
          ),
          /*ListTile(
            leading: Icon(Icons.account_circle_outlined),
            title: Text('Kayıt'),
            onTap: () => {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Register()),
                  ModalRoute.withName("/kayit"))
            },
          ),*/

          ListTile(
            leading: Icon(Icons.list),
            title: Text('Kategoriler'),
            onTap: () => {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Categories()),
                  ModalRoute.withName("/kategoriler"))
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance_sharp),
            title: Text('İş İlanları'),
            onTap: () => {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Announcements()),
                  ModalRoute.withName("/ilanlar"))
            },
          ),
          /* ListTile(
            leading: Icon(Icons.people),
            title: Text('İştirakler'),
            onTap: () => {Navigator.of(context).pop()},
          ),*/

          Visibility(
              child: ListTile(
                leading: Icon(Icons.security),
                title: Text('Giriş'),
                onTap: () => {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                      ModalRoute.withName("/giris"))
                },
              ),
              visible: !KariyerHelper.isLogin),
          Visibility(
              child: ListTile(
                leading: Icon(Icons.description),
                title: Text('Genel Bilgiler'),
                onTap: () => {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MemberContactInfo()),
                      ModalRoute.withName("/uye-iletisim-bilgileri"))
                },
              ),
              visible: KariyerHelper.isLogin),
          Visibility(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('Kişisel Bilgiler'),
                onTap: () => {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => PersonelInfo()),
                      ModalRoute.withName("/uye-kisisel-bilgiler"))
                },
              ),
              visible: KariyerHelper.isLogin),
          Visibility(
              child: ListTile(
                leading: Icon(Icons.add_chart),
                title: Text('İş Deneyimleri'),
                onTap: () => {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MemberExperience()),
                      ModalRoute.withName("/calisma-hayati-gecmisi"))
                },
              ),
              visible: KariyerHelper.isLogin),
          Visibility(
              child: ListTile(
                leading: Icon(Icons.menu_book),
                title: Text('Eğitim Geçmişi'),
                onTap: () => {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MemberEducation()),
                      ModalRoute.withName("/egitim-gecmisi"))
                },
              ),
              visible: KariyerHelper.isLogin),
          Visibility(
              child: ListTile(
                leading: Icon(Icons.people_alt_outlined),
                title: Text('Referanslarım'),
                onTap: () => {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MemberReferance()),
                      ModalRoute.withName("/referanslarim"))
                },
              ),
              visible: KariyerHelper.isLogin),
          Visibility(
              child: ListTile(
                leading: Icon(Icons.all_inbox),
                title: Text('Belgelerim'),
                onTap: () => {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MemberDocument()),
                      ModalRoute.withName("/dokumanlar"))
                },
              ),
              visible: KariyerHelper.isLogin),
          Visibility(
              child: ListTile(
                leading: Icon(Icons.star),
                title: Text('Yetkinliklerim'),
                onTap: () => {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MemberCompetence()),
                      ModalRoute.withName("/yetkinlikler"))
                },
              ),
              visible: KariyerHelper.isLogin),
          Visibility(
              child: ListTile(
                leading: Icon(Icons.input),
                title: Text('Çıkış'),
                onTap: () {
                  KariyerHelper.isLogin = false;
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Blog()),
                      ModalRoute.withName("/blog"));
                },
              ),
              visible: KariyerHelper.isLogin)
        ],
      ),
    );
  }
}
