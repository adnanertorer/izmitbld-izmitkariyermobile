class MilitaryService{
  int? id;
  String? serviceName;

  MilitaryService({
    this.id,
    this.serviceName
  });

  factory MilitaryService.fromJson(Map<String, Map> json){
    return MilitaryService(
        id: json["id"] as int,
        serviceName: json["serviceName"] as String
    );
  }


}