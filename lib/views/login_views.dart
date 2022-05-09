import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

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
                            .signInWithEmailAndPassword(
                                email: userEmail, password: userPassword);
                        print(userCredential);
                        print('the user Exists!');
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print('user is not found');
                          print(e.code);
                        } else if (e.code == 'wrong-password') {
                          print('Wrong Password!');
                          print(e.code);
                        }
                      }
                    },
                    child: const Text('Login'),
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
