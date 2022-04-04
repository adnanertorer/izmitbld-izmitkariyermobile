class BlogModel {
  int? id;
  String? title;
  String? description;
  String? blogText;
  String? blogImage;
  DateTime? createdAt;
  int? creatadBy;

  BlogModel(
      {this.description,
      this.blogImage,
      this.blogText,
      this.creatadBy,
      this.createdAt,
      this.id,
      this.title});

  factory BlogModel.fromJson(Map<String, Map> json){
    return BlogModel(
      id: json["id"] as int,
      description: json["description"] as String,
      blogImage: json["blogImage"] as String,
      creatadBy: json["creatadBy"] as int,
      createdAt: json["createdAt"] as DateTime,
      title: json["title"] as String,
      blogText: json["blogText"] as String,
    );}
}
