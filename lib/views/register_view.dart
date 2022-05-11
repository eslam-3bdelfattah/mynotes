import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devTool show log;

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  //define two vars for email and password fields values
  late final TextEditingController email;
  late final TextEditingController password;

  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          //email field
          TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Enter you email'),
          ),
          //password field
          TextField(
            controller: password,
            autocorrect: false,
            enableSuggestions: false,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Enter you password'),
          ),
          TextButton(
            onPressed: () async {
              final userEmail = email.text;
              final userPassword = password.text;
              try {
                final userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: userEmail, password: userPassword);
                devTool.log(userCredential.toString());
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  devTool.log('weak password');
                } else if (e.code == 'email-already-in-use') {
                  devTool.log('email already in use try another one');
                } else if (e.code == 'invalid-email') {
                  devTool.log('invalid email enter a correct one');
                }
              }
            },
            child: const Text('Register'),
          ),
          //button for login view
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                'login',
                (route) => false,
              );
            },
            child: const Text("Already have an account? Login here"),
          )
        ],
      ),
    );
  }
}
