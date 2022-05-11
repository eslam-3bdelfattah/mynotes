import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devTools show log;

import 'package:mynotes/components/components.dart';
import 'package:mynotes/constants/routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text('Login'),
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
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: userEmail, password: userPassword);
                devTools.log('the user exists!');
                //after you sign in successfully go to your notes
                namedNavigator(route: notesRoute, context: context);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  //take the user to register an account because his account is not found
                  namedNavigator(route: registerRoute, context: context);
                  devTools.log('user is not found!');
                } else if (e.code == 'wrong-password') {
                  devTools.log('Wrong password.. type a correct password');
                }
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              namedNavigator(route: registerRoute, context: context);
            },
            child: const Text("Don't have an account? Resgiter here"),
          )
        ],
      ),
    );
  }
}
