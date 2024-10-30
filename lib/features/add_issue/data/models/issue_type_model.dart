import 'subcategory_model.dart';

class IssueType {
  final int id;
  final int subcategoryId;
  final String name;
  final Subcategory
      subcategory; // This will be the subcategory this issue type is linked to

  IssueType({
    required this.id,
    required this.subcategoryId,
    required this.name,
    required this.subcategory,
  });

  factory IssueType.fromJson(Map<String, dynamic> json) {
    return IssueType(
      id: json['id'],
      subcategoryId: json['subcategoryId'],
      name: json['name'],
      subcategory: Subcategory.fromJson(json['issuetypeSubcategory']),
    );
  }
}
