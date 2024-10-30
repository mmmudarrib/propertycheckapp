import 'package:equatable/equatable.dart';

import '../data/models/category_model.dart';
import '../data/models/issue_type_model.dart';
import '../data/models/subcategory_model.dart';

// Abstract class for the states
abstract class IssueFormState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Initial state
class IssueFormInitial extends IssueFormState {}

// State when data is loading
class IssueFormLoading extends IssueFormState {}

// State when categories are loaded
class CategoriesLoaded extends IssueFormState {
  final List<Category> categories;

  CategoriesLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

// State when subcategories are loaded
class SubcategoriesLoaded extends IssueFormState {
  final List<Subcategory> subcategories;

  SubcategoriesLoaded({required this.subcategories});

  @override
  List<Object?> get props => [subcategories];
}

// State when issue types are loaded
class IssueTypesLoaded extends IssueFormState {
  final List<IssueType> issueTypes;

  IssueTypesLoaded({required this.issueTypes});

  @override
  List<Object?> get props => [issueTypes];
}

// Error state
class IssueFormError extends IssueFormState {
  final String errorMessage;

  IssueFormError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
