class SelectItemModel{
  int? id;
  String? value;

  SelectItemModel({this.value, this.id});

  factory SelectItemModel.fromJson(Map<String, Map> json) {
    return SelectItemModel(
        id: json["id"] as int,
        value: json["value"] as String);
  }
}