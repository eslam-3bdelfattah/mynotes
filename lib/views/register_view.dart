import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

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
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          //snapshot is the state of my futurebuilder (done - faild - none)
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  //email field
                  TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(hintText: 'Enter you email'),
                  ),
                  //password field
                  TextField(
                    controller: password,
                    autocorrect: false,
                    enableSuggestions: false,
                    obscureText: true,
                    decoration:
                        const InputDecoration(hintText: 'Enter you password'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final userEmail = email.text;
                      final userPassword = password.text;
                      try {
                        final userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: userEmail, password: userPassword);
                        print(userCredential);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('Weak password');
                        } else if (e.code == 'email-already-in-use') {
                          print('this email is already in use try another one');
                        } else if (e.code == 'invalid-email') {
                          print('this email is invalid');
                        }
                      }
                    },
                    child: const Text('Register'),
                  ),
                ],
              );
              break;
            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}
