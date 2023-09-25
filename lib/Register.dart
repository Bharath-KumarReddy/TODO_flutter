import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:usingfirebase/Login.dart';



class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController Controller = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

 Future<void> _registerUser() async {
 
  final email = emailController.text.trim();
  final password = passwordController.text;

  
  if ( email.isEmpty || password.isEmpty) {
   
    Get.defaultDialog(
      title: 'Error',
      content: Text('All fields are required.'),
      textCancel: 'OK',
    );
    return; 
  }

  try {
    final authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await FirebaseFirestore.instance.collection('users').doc(authResult.user?.uid).set({
      
      'email': email,
    });

    Get.to(() => SignInPage());
  } catch (error) {
    print('Registration Error: $error');
    
  }
}


  @override
  void dispose() {
    Controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up' , style : TextStyle(color : Colors.red)),
      ),
      body: Container(
        decoration: BoxDecoration(
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
              // TextField(
              //   controller: Controller,
              //   decoration: InputDecoration(
              //     labelText: '',
              //     icon: Icon(Icons.person),
              //   ),
              // ),
              SizedBox(height: 16.0),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _registerUser,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.person_add),
                    SizedBox(width: 8.0),
                    Text('Sign Up'),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Already have an account?'),
                  TextButton(
                    onPressed: () {
                      // Navigate to the sign-in page
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Sign In',
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
