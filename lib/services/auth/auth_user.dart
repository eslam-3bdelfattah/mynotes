import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable //it means this class is not going to change
class AuthUser {
  final bool isEmailVerified;
  const AuthUser(this.isEmailVerified);

  //to check whether the user is verified or not
  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}
