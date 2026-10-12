/// Category Model for SMUCT Lost & Found Items
class CategoryModel {
  final String categoryId;
  final String categoryName;
  final String iconName;

  String get id => categoryId;
  String get name => categoryName;

  CategoryModel({
    required this.categoryId,
    required this.categoryName,
    required this.iconName,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map, String id) {
    return CategoryModel(
      categoryId: id,
      categoryName: map['categoryName'] ?? '',
      iconName: map['iconName'] ?? 'folder',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryName': categoryName,
      'iconName': iconName,
    };
  }
}
