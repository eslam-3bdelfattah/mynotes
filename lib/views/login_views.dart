import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devTools show log;
import 'package:mynotes/components/named_navigator.dart';
import 'package:mynotes/constants/routes.dart';
import '../components/show_error_dialog.dart';

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
                final user = FirebaseAuth.instance.currentUser;
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: userEmail, password: userPassword);
                //make sure that the user verifies his email before going to main view
                if (user?.emailVerified ?? false) {
                  namedNavigator(route: notesRoute, context: context);
                } else {
                  namedNavigator(route: verifyRoute, context: context);
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  //take the user to register an account because his account is not found
                  //namedNavigator(route: registerRoute, context: context);
                  showErrorDialog(
                    context: context,
                    errorText: 'User is not found',
                  );
                  devTools.log('user is not found!');
                } else if (e.code == 'wrong-password') {
                  devTools.log('Wrong password.. type a correct password');
                  showErrorDialog(
                      context: context,
                      errorText: 'Wrong password, please enter a correct one');
                } else {
                  showErrorDialog(
                    context: context,
                    errorText: 'Error: ${e.code}',
                  );
                }
              } catch (e) {
                showErrorDialog(
                  context: context,
                  errorText: e.toString(),
                );
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
