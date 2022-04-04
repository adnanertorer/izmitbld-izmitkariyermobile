import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izmitbld_kariyer/announcements.dart';
import 'package:izmitbld_kariyer/blog.dart';
import 'package:izmitbld_kariyer/forgot-password-step-one.dart';
import 'package:izmitbld_kariyer/forgot-password-step-two.dart';
import 'package:izmitbld_kariyer/main_page.dart';
import 'package:izmitbld_kariyer/member-add/add-education.dart';
import 'package:izmitbld_kariyer/member-add/add-experience.dart';
import 'package:izmitbld_kariyer/member-add/add-referance.dart';
import 'package:izmitbld_kariyer/member_details/member-contact-info.dart';
import 'package:izmitbld_kariyer/member_details/member-document.dart';
import 'package:izmitbld_kariyer/member_details/member-education.dart';
import 'package:izmitbld_kariyer/member_details/member-experiences.dart';
import 'package:izmitbld_kariyer/member_details/member-referance.dart';
import 'package:izmitbld_kariyer/member_details/personal-info.dart';
import 'package:izmitbld_kariyer/member_edit/experience-edit.dart';
import 'package:izmitbld_kariyer/member_edit/member-document-add.dart';
import 'package:izmitbld_kariyer/register.dart';
import 'package:izmitbld_kariyer/tools/categories.dart';

import 'announcement_details.dart';
import 'login.dart';
import 'member_details/member-competence.dart';
import 'nav_drawer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Blog(),
      routes: <String, WidgetBuilder>{
        '/kategoriler': (BuildContext context) => Categories(),
        '/anasayfa': (BuildContext context) => MainPage(),
        '/ilanlar': (BuildContext context) => Announcements(),
        '/ilan-detay': (BuildContext context) => AnnouncementDetails(),
        '/kayit': (BuildContext context) => Register(),
        '/giris': (BuildContext context) => Login(),
        '/uye-iletisim-bilgileri': (BuildContext context) =>
            MemberContactInfo(),
        '/uye-kisisel-bilgiler': (BuildContext context) =>
            PersonelInfo(),
        '/calisma-hayati-gecmisi': (BuildContext context) =>
            MemberExperience(),
        '/egitim-gecmisi': (BuildContext context) =>
            MemberEducation(),
        '/referanslarim': (BuildContext context) =>
            MemberReferance(),
        '/dokumanlar': (BuildContext context) =>
            MemberDocument(),
        '/yetkinlikler': (BuildContext context) =>
            MemberCompetence(),
        '/calisma-detay': (BuildContext context) =>
            ExperienceEdit(),
        '/belge-ekle': (BuildContext context) =>
            MemberDocumentAdd(),
        '/blog': (BuildContext context) =>
            Blog(),
        '/parola-hatirlat-adim-bir': (BuildContext context) =>
            ForgotPasswordStepOne(),
        '/parola-hatirlat-adim-iki': (BuildContext context) =>
            ForgotPasswordStepTwo(),
        '/deneyim-ekle': (BuildContext context) =>
            AddMemberExperience(),
        '/okul-ekle': (BuildContext context) =>
            AddEducation(),
        '/referans-ekle': (BuildContext context) =>
            AddReferance(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Kariyer İzmit'),
      ),
      body: Center(
        child: Text('İzmit Belediyesi'),
      ),
    );
  }
}
