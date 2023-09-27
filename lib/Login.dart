import 'dart:async'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:usingfirebase/Home.dart';
import 'package:usingfirebase/Register.dart';

void main() async {
  runApp(MaterialApp(
    home: SignInPage(),
    theme: ThemeData(primaryColor: Colors.deepPurple),
  ));
}

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;
  late Timer errorMessageTimer; 

  @override
  void initState() {
    super.initState();
    errorMessageTimer = Timer(const Duration(seconds: 5), () {
      setState(() {
        errorMessage = null; 
      });
    });
  }

 Future<void> _signIn() async {
  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  try {
    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: email,
          password: password,
        );

    final User? user = userCredential.user;

    Get.to(() => Home());
  } catch (error) {
    Get.defaultDialog(
      title: 'Error',
      middleText: 'Invalid credentials. Please try again.',
      textConfirm: 'OK',
      onConfirm: () {
        Get.back();
      },
    );

    print('Sign In Error: $error');
  }
}


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    errorMessageTimer.cancel(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightBlue, Colors.white],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Center(
                child: Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  icon: Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                     
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _signIn,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.login),
                    SizedBox(width: 8.0),
                    Text('Sign In'),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () {
                      Get.to(() => SignUpPage());
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
