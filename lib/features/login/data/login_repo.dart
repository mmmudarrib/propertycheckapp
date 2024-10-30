import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/encryption_service.dart';
import '../../dashboard/pages/dashboard.dart';

class LoginRepository {
  static const String loginUrl =
      'https://ilovebackend.propertycheck.me/api/user/auth/email';

  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Prepare the request body
      final Map<String, String> body = {
        "email": email,
        "password": encryptAESCryptoJS(password, 'nKYNZguO7q6iAxWph5eS'),
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      // Check if the login was successful
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final String token = responseData['token'];

        // Decode the JWT token to get the role ID and user ID
        final decodedToken = JwtDecoder.decode(token);
        final int roleId = decodedToken['roleId'];
        final int userId = decodedToken['id'];

        // Store the role ID and user ID in shared preferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('roleId', roleId);
        await prefs.setInt('userId', userId);
        await prefs.setString('token', token);

        // Check if the user is an inspector (roleId == 2)
        if (roleId != 2) {
          // Show an error toast if the user is not an inspector
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: User is not an inspector')),
          );
        } else {
          // Navigate to the dashboard if the user is an inspector
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        }
      } else {
        // Show an error toast with the message from the response
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
      }
    } catch (e) {
      // Handle any errors that occur during the request
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
