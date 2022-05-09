import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/views/login_views.dart';
import 'package:mynotes/views/register_view.dart';
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
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          //snapshot is the state of my futurebuilder (done - faild - none)
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance
                  .currentUser; //if the future has successeded do this :
              if (user?.emailVerified ?? false) {
                print('this email is verfied');
              } else {
                print('you need to verify your email');
              }
              return const Text('Done');
              break;
            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}
