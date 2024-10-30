import 'package:equatable/equatable.dart';

// Abstract class for the events
abstract class IssueFormEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Event for loading all categories
class LoadCategories extends IssueFormEvent {}

// Event for loading subcategories based on the selected category
class LoadSubcategories extends IssueFormEvent {
  final int categoryId;

  LoadSubcategories({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

// Event for loading issue types based on the selected subcategory
class LoadIssueTypes extends IssueFormEvent {
  final int subcategoryId;

  LoadIssueTypes({required this.subcategoryId});

  @override
  List<Object?> get props => [subcategoryId];
}
