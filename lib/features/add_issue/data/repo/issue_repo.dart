import '../datasources/issue_remote_datasource.dart';
import '../models/category_model.dart';
import '../models/issue_type_model.dart';
import '../models/subcategory_model.dart';

class IssueRepository {
  final IssueRemoteDataSource remoteDataSource;

  IssueRepository({
    required this.remoteDataSource,
  });

  Future<List<Category>> getCategories() async {
    try {
      final categories = await remoteDataSource.fetchCategories();
      return categories;
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<List<Subcategory>> getSubcategories() async {
    try {
      final subcategories = await remoteDataSource.fetchSubcategories();
      return subcategories;
    } catch (e) {
      throw Exception('Failed to load subcategories: $e');
    }
  }

  Future<List<IssueType>> getIssueTypes() async {
    try {
      final issueTypes = await remoteDataSource.fetchIssueTypes();
      return issueTypes;
    } catch (e) {
      throw Exception('Failed to load issue types: $e');
    }
  }
}
