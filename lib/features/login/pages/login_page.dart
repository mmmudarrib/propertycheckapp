import 'package:flutter/material.dart';

import '../data/login_repo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D1D1B),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 60,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffB7B7B7),
                  hintText: 'Enter your email here....',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontFamily: "GothamBook",
                    fontWeight: FontWeight.w400,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffB7B7B7),
                  hintText: 'Enter your password here....',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontFamily: "GothamBook",
                    fontWeight: FontWeight.w400,
                  ),
                  suffixIcon: const Icon(
                    Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: loading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {}, // Opens bbarray.com when clicked
                child: RichText(
                  text: const TextSpan(
                    text: 'Built with passion by ', // Regular text
                    style: TextStyle(
                      color: Colors.grey, // Keep other text white
                      decoration:
                          TextDecoration.none, // No underline for this part
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'BBArray', // BBArray styled differently
                        style: TextStyle(
                          color: Colors.green, // Green color for BBArray
                          // Bold for BBArray
                          // Underlined for BBArray
                        ),
                      ),
                      TextSpan(
                        text:
                            ' - Version 1.0.5', // Regular text for the version
                        style: TextStyle(
                          color: Colors.grey, // Keep the version text white
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
      ),
    );
  }
}
