import 'package:flutter/material.dart';
import 'package:mynotes/components/named_navigator.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
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
                final user = AuthService.firebase().currentUser;
                await AuthService.firebase()
                    .logIn(email: userEmail, password: userPassword);
                //make sure that the user verifies his email before going to main view
                if (user?.isEmailVerified ?? false) {
                  namedNavigator(route: notesRoute, context: context);
                } else {
                  namedNavigator(route: verifyRoute, context: context);
                }
              } on UserNotFoundAuthException {
                showErrorDialog(
                  context: context,
                  errorText: 'User is not found',
                );
              } on WrongPasswordAuthvException {
                showErrorDialog(
                  context: context,
                  errorText: 'Wrong password, please enter a correct one',
                );
              } on GenericAuthExceptions {
                showErrorDialog(
                  context: context,
                  errorText: 'Auth error!',
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
