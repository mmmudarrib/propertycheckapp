import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../widgets/rounded_button_widget.dart';
import '../../../widgets/rounded_text_field_widget.dart';
import '../data/login_repo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: (loading)
          ? Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : SingleChildScrollView(
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
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      final loginRepo = LoginRepository();
                      await loginRepo.login(
                        email: emailController.text,
                        password: passwordController.text,
                        context: context,
                      );
                      setState(() {
                        loading = false;
                      });
                    },
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 20.0),
                  // Forgot password
                  TextButton(
                    onPressed: () {}, // Opens bbarray.com when clicked
                    child: RichText(
                      text: const TextSpan(
                        text: 'Built with passion by ', // Regular text
                        style: TextStyle(
                          color: Colors.white, // Keep other text white
                          decoration:
                              TextDecoration.none, // No underline for this part
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'BBArray', // BBArray styled differently
                            style: TextStyle(
                              color: Colors.green, // Green color for BBArray
                              fontWeight: FontWeight.bold, // Bold for BBArray
                              decoration: TextDecoration
                                  .underline, // Underlined for BBArray
                            ),
                          ),
                          TextSpan(
                            text:
                                ' - Version 1.0.5', // Regular text for the version
                            style: TextStyle(
                              color:
                                  Colors.white, // Keep the version text white
                              decoration: TextDecoration
                                  .none, // No underline for the version text
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
