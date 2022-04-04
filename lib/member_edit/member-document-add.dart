import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:izmitbld_kariyer/member_details/member-document.dart';
import 'package:izmitbld_kariyer/model/document-type-model.dart';
import 'package:izmitbld_kariyer/tools/SharedPreferencesHelper.dart';
import 'package:izmitbld_kariyer/tools/custom-date-picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

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

class MemberDocumentAdd extends StatefulWidget {
  @override
  MemberDocumentAddState createState() => MemberDocumentAddState();
}

class MemberDocumentAddState extends State<MemberDocumentAdd> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _controller = TextEditingController();
  List<DocumentTypeModel> typeList = <DocumentTypeModel>[];
  DocumentTypeModel selectedDocumentType = new DocumentTypeModel();
  var txtValidDate = TextEditingController();
  String validDate = "";
  FilePickerResult? result;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    typeList.add(new DocumentTypeModel(
        documentTypeName: "Seçiniz", memberDocumentId: 0));
    typeList.add(new DocumentTypeModel(
        documentTypeName: "SRC Belgesi", memberDocumentId: 1));
    typeList.add(new DocumentTypeModel(
        documentTypeName: "MYK Belgesi", memberDocumentId: 2));
    typeList.add(new DocumentTypeModel(
        documentTypeName: "Psikoteknik Belgesi", memberDocumentId: 4));
    typeList.add(new DocumentTypeModel(
        documentTypeName: "YDS Sınav Sonucu", memberDocumentId: 5));
    typeList.add(new DocumentTypeModel(
        documentTypeName: "Sertifika", memberDocumentId: 6));
    typeList.add(new DocumentTypeModel(
        documentTypeName: "Diploma", memberDocumentId: 7));
    typeList.add(new DocumentTypeModel(
        documentTypeName: "Özgeçmiş", memberDocumentId: 8));
    typeList.add(new DocumentTypeModel(
        documentTypeName: "Güvenlik (Silahlı)", memberDocumentId: 9));
    typeList.add(new DocumentTypeModel(
        documentTypeName: "Güvenlik (Silahsız)", memberDocumentId: 10));
    typeList.add(new DocumentTypeModel(
        documentTypeName: "İkametgah", memberDocumentId: 11));
    typeList.add(
        new DocumentTypeModel(documentTypeName: "Diğer", memberDocumentId: 12));
    selectedDocumentType =
        typeList.where((element) => element.memberDocumentId == 0).first;
    txtValidDate.text = validDate;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _sendToServer() async{
    setState(() {
      isLoading = true;
    });
    var token = await SharedPreferencesHelper.getTokenKey();
    if (result != null) {
      if(selectedDocumentType.memberDocumentId!=0){
        try {
          print(result!.paths[0].toString());

          String filename = result!.files.single.name;
          print(filename);

          String apiUrl = SharedPreferencesHelper.getApiAddress() +
              "MemberDocument/UploadMemberFile";

          MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(apiUrl));

          request.headers['authorization'] = 'Bearer $token';
          request.files.add(http.MultipartFile(
              'file',
              File(result!.paths[0].toString()).readAsBytes().asStream(),
              File(result!.paths[0].toString()).lengthSync(),
              filename: filename.split("/").last));
          request.fields["docFileName"] = filename;
          request.fields["documentTypeId"] =
              selectedDocumentType.memberDocumentId.toString();
          request.fields["validDate"] = validDate.toString();
          var res = await request.send();
          if (res.statusCode == 200) {
            setState(() {
              validDate = "";
              selectedDocumentType.memberDocumentId = 0;
              selectedDocumentType.documentTypeName = "Seçiniz";
              isLoading = false;
            });

            await _showMyDialog("Dosyanız kaydedildi", "Tebrikler", context);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MemberDocument()),
                ModalRoute.withName("/dokumanlar"));
          } else {}
        } catch (e) {
          setState(() {
            isLoading = false;
          });
          print(e);
          await _showMyDialog(e.toString(), "Bir sorun oluştu", context);
        }
      }else{
        setState(() {
          isLoading = false;
        });
        await _showMyDialog("Lütfen bir belge türü seçiniz", "Eksik Bilgi", context);
      }

    }else{
      setState(() {
        isLoading = false;
      });
      await _showMyDialog("Lütfen bir dosya seçiniz", "Eksik Bilgi", context);
    }
  }

  Future _openFileExplorer() async {
    try {
      result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: [
            'jpg',
            'pdf',
            'doc',
            'docx',
            'xls',
            'xlsx',
            'txt'
          ],
          allowMultiple: false);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text("Belge Gönder"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, false);
            }),
      ),
      resizeToAvoidBottomInset: true,
      // klavyenin text alanını ezmesini engeller
      body: Center(
        child: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            reverse: false,
            child: Column(children: <Widget>[
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Text('Belge Türü'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: DropdownButton<DocumentTypeModel>(
                  isExpanded: true,
                  value: selectedDocumentType,
                  icon: const Icon(Icons.arrow_circle_down_sharp),
                  iconSize: 24,
                  elevation: 16,
                  onChanged: (DocumentTypeModel? newValue) {
                    setState(() {
                      selectedDocumentType = newValue!;
                    });
                  },
                  items: typeList.map<DropdownMenuItem<DocumentTypeModel>>(
                      (DocumentTypeModel? value) {
                    return DropdownMenuItem<DocumentTypeModel>(
                      value: value,
                      child: Text(value!.documentTypeName.toString()),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Text(validDate.length>0 ? "Geçerlilik Tarihi : "+validDate.replaceAll("T00:00:00.000", ""):"", textAlign: TextAlign.center,
                ),
              ),
              TextButton(
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2010, 12, 1),
                        maxTime: DateTime(2030, 12, 1), onChanged: (date) {
                      print('change $date');
                    }, onConfirm: (date) {
                      setState(() {
                        print('change $date');
                        validDate = date.toIso8601String();
                      });
                    }, currentTime: DateTime.now(), locale: LocaleType.tr);
                  },
                  child: Text(
                    'Belgenizin geçerlilik tarihi varsa buraya dokunup seçiniz',
                    style: TextStyle(color: Colors.blue),
                  )),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: new RaisedButton(
                    onPressed: () async => {_openFileExplorer()},
                    color: Colors.blue,
                    child: Text('Belge Seçin'),
                    textColor: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: new RaisedButton(
                    onPressed: () async => {_sendToServer()},
                    color: Colors.blue,
                    child: Text('Gönder'),
                    textColor: Colors.white,
                  ),
                ),
              ),
            ]),
          );
        }),
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
