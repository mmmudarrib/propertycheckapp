import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../widgets/rounded_button_widget.dart';
import '../../../widgets/rounded_text_field_widget.dart';
import '../../dashboard/pages/dashboard.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80.0),
            // Logo at the top
            Image.asset(
              'assets/images/logo.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 40.0),
            // Welcome text
            const Text(
              'Welcome to Property Check',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40.0),
            // Email field
            RoundedTextField(
              controller: emailController,
              hintText: 'Email',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email, color: Colors.white),
            ),
            const SizedBox(height: 20.0),
            // Password field
            RoundedTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
              prefixIcon: const Icon(Icons.lock, color: Colors.white),
            ),
            const SizedBox(height: 40.0),
            // Login button
            RoundedButton(
              text: 'Login',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashboardScreen()),
                );
              },
              color: AppColors.primaryColor,
            ),
            const SizedBox(height: 20.0),
            // Forgot password
            TextButton(
              onPressed: () {
                // Handle forgot password action
                print('Forgot Password pressed');
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
