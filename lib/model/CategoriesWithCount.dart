class CategoriesWithCount{
  int? categoryId;
  String? categoryName;
  int? totalAdByCategory;
  String? iconName;

  CategoriesWithCount({
     this.categoryId,
     this.categoryName,
     this.iconName,
     this.totalAdByCategory
  });

  factory CategoriesWithCount.fromJson(Map<String, Map> json){
    return CategoriesWithCount(
      categoryId: json["categoryId"] as int,
      categoryName: json["categoryName"] as String,
      iconName: json["iconName"] as String,
      totalAdByCategory: json["totalAdByCategory"] as int
    );
  }

  Map<String, dynamic> toJson() => {
    "categoryId": categoryId,
    "categoryName": categoryName,
    "iconName": iconName,
    "totalAdByCategory": totalAdByCategory
  };

}