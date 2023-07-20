class CategoryModel{
  int s;
  String m;
  List<Category> category;

  CategoryModel({
    this.s = 0,
    this.m = "",
    this.category = const[],
});
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    try {
      for (var element in json.keys) {
        print('$element ${json[element].runtimeType}');
      }
      return CategoryModel(
          s: int.tryParse('${json['s']}') ?? 0,
          m: json['m'] ?? "",
          category: List<Category>.from(
              (json['r'] ?? []).map((x) => Category.fromJson(x))));
    } catch (e) {
      print('$e');
      return CategoryModel();
    }
  }

  Map<String, dynamic> toJson() => {
    "s": s,
    "m": m,
    "r": category,
  };

}
class Category {
  int id;
  String categoryName;

  Category({
    this.id = 0,
    this.categoryName = "",
  });

  int index = 0;

  factory Category.fromJson(Map<String, dynamic> json) {
    try {
      return Category(
        id: int.tryParse('${json['id']}') ?? 0,
        categoryName: json['category_name'] ?? "".toString(),
      );
    } catch (e) {
      print('$e');
      return Category();
    }
  }


}