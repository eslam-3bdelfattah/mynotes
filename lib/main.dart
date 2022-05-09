import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/views/login_views.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  //it makes sure that everything is ready before building the app
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      'login': (context) => const LoginView(),
      'register': (context) => const RegisterView(),
      //'logout':(context) =>
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        //snapshot is the state of my futurebuilder (done - faild - none)
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                print('your mail is verified');
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
            return const Text('Done');
          // if (user?.emailVerified ?? false) {
          //   print('this email is verfied');
          // } else {
          //   return const VerifyEmailView();
          // }
          // return const Text('Done');
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
