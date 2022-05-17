import 'package:flutter/material.dart';
import 'package:mynotes/components/named_navigator.dart';
import 'package:mynotes/components/show_error_dialog.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';

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
                await AuthService.firebase().createUser(
                  email: userEmail,
                  password: userPassword,
                );
                await AuthService.firebase().verifyUserEmail();
                Navigator.of(context).pushNamed('verify');
              } on WeakPassowordAuthException {
                showErrorDialog(
                  context: context,
                  errorText: 'weak passoword',
                );
              } on EmailInUseAuthException {
                showErrorDialog(
                  context: context,
                  errorText: 'this email is already in use try another email',
                );
              } on InvalidEmailAuthException {
                showErrorDialog(
                  context: context,
                  errorText: 'Invalid email please try again',
                );
              } on GenericAuthExceptions {
                showErrorDialog(
                  context: context,
                  errorText: 'Auth error!',
                );
              }
            },
            child: const Text('Register'),
          ),
          //button for login view
          TextButton(
            onPressed: () {
              namedNavigator(route: loginRoute, context: context);
            },
            child: const Text("Already have an account? Login here"),
          )
        ],
      ),
    );
  }
}
