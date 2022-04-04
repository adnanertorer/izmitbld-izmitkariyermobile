class VMemberDocuments {
  int? memberDocumentId;
  int? documentTypeId;
  String? documentTypeName;
  String? documentFileName;
  String? documentFilePatch;
  int? memberId;

  VMemberDocuments(
      {this.memberId,
      this.documentFileName,
      this.documentFilePatch,
      this.documentTypeId,
      this.documentTypeName,
      this.memberDocumentId});

  factory VMemberDocuments.fromJson(Map<String, Map> json){
    return VMemberDocuments(
      memberId: json["memberId"] as int,
      documentFileName: json["documentFileName"] as String,
      documentFilePatch: json["documentFilePatch"] as String,
      documentTypeId: json["documentTypeId"] as int,
      documentTypeName: json["documentTypeName"] as String,
      memberDocumentId: json["memberDocumentId"] as int,
    );}
}
