import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/category_model.dart';
import '../models/issue_type_model.dart';
import '../models/subcategory_model.dart';

class IssueRemoteDataSource {
  final String baseUrl = 'https://ilovebackend.propertycheck.me/api/';

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/category'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Subcategory>> fetchSubcategories() async {
    final response = await http.get(Uri.parse('$baseUrl/subcategory'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((json) => Subcategory.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load subcategories');
    }
  }

  Future<List<IssueType>> fetchIssueTypes() async {
    final response = await http.get(Uri.parse('$baseUrl/issuetype'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((json) => IssueType.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load issue types');
    }
  }
}
