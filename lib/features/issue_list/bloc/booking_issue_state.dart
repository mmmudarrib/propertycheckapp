import 'package:equatable/equatable.dart';
import 'package:propertycheckapp/features/issue_list/data/model/issue_list.dart';

// Abstract class for all states
abstract class IssueListState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Initial state before data is loaded
class IssueListInitial extends IssueListState {}

// Loading state while fetching issues
class IssueListLoading extends IssueListState {}

// Loaded state when issues are fetched successfully
class IssueListLoaded extends IssueListState {
  final List<Issue> issues;

  IssueListLoaded(this.issues);

  @override
  List<Object?> get props => [issues];
}

// Error state if fetching issues fails
class IssueListError extends IssueListState {
  final String error;

  IssueListError(this.error);

  @override
  List<Object?> get props => [error];
}