class SectorTypeModel {
  int? sectorTypeId;
  String? typeName;

  SectorTypeModel({this.typeName, this.sectorTypeId});

  factory SectorTypeModel.fromJson(Map<String, Map> json) {
    return SectorTypeModel(
        sectorTypeId: json["sectorTypeId"] as int,
        typeName: json["typeName"] as String);
  }
}