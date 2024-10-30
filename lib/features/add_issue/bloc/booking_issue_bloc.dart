import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repo/issue_repo.dart';
import 'booking_issue_event.dart';
import 'booking_issue_states.dart';

class IssueFormBloc extends Bloc<IssueFormEvent, IssueFormState> {
  final IssueRepository repository;

  IssueFormBloc({required this.repository}) : super(IssueFormInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<LoadSubcategories>(_onLoadSubcategories);
    on<LoadIssueTypes>(_onLoadIssueTypes);
  }

  // Handler for loading categories
  Future<void> _onLoadCategories(
      LoadCategories event, Emitter<IssueFormState> emit) async {
    emit(IssueFormLoading());
    try {
      final categories = await repository.getCategories();
      emit(CategoriesLoaded(categories: categories));
    } catch (e) {
      emit(IssueFormError(errorMessage: 'Failed to load categories: $e'));
    }
  }

  // Handler for loading subcategories based on selected category
  Future<void> _onLoadSubcategories(
      LoadSubcategories event, Emitter<IssueFormState> emit) async {
    emit(IssueFormLoading());
    try {
      final subcategories =
          await repository.getSubcategories(); // Fetch all subcategories
      // Filter subcategories based on selected categoryId
      final filteredSubcategories = subcategories
          .where((subcategory) => subcategory.categoryId == event.categoryId)
          .toList();
      emit(SubcategoriesLoaded(subcategories: filteredSubcategories));
    } catch (e) {
      emit(IssueFormError(errorMessage: 'Failed to load subcategories: $e'));
    }
  }

  // Handler for loading issue types based on selected subcategory
  Future<void> _onLoadIssueTypes(
      LoadIssueTypes event, Emitter<IssueFormState> emit) async {
    emit(IssueFormLoading());
    try {
      final issueTypes =
          await repository.getIssueTypes(); // Fetch all issue types
      // Filter issue types based on selected subcategoryId
      final filteredIssueTypes = issueTypes
          .where((issueType) => issueType.subcategoryId == event.subcategoryId)
          .toList();
      emit(IssueTypesLoaded(issueTypes: filteredIssueTypes));
    } catch (e) {
      emit(IssueFormError(errorMessage: 'Failed to load issue types: $e'));
    }
  }
}
