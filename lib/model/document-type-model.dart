class DocumentTypeModel{
  int? memberDocumentId;
  String? documentTypeName;

  DocumentTypeModel({this.documentTypeName, this.memberDocumentId});

  factory DocumentTypeModel.fromJson(Map<String, Map> json){
    return DocumentTypeModel(
        memberDocumentId: json["memberDocumentId"] as int,
        documentTypeName: json["documentTypeName"] as String
    );
  }
}