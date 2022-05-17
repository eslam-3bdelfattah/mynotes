import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text(
              'An verifacation email was sent, please confirm your email'),
          const Text(
              "if you aren't verfied yet click here to send verifacation email"),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().verifyUserEmail();
            },
            child: const Text('Verify'),
          ),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                //sign out from firebase then go to register
                Navigator.of(context).pushNamed(registerRoute);
              },
              child: const Text('Sign out'))
        ],
      ),
    );
  }
}
