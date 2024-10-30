import 'category_model.dart'; // Ensure you import the Category model

class Subcategory {
  final int id;
  final int categoryId;
  final String name;
  final Category
      category; // This will be the category this subcategory is linked to

  Subcategory({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.category,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'],
      categoryId: json['categoryId'] ?? -1,
      name: json['name'],
      category: Category.fromJson(json['subcategoryCategory']),
    );
  }
}
