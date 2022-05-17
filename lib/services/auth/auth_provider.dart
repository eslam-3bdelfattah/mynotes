import 'package:mynotes/services/auth/auth_user.dart';

//this class will be the interface to all of our auth process
abstract class AuthProvider {
  //intialize firebase
  Future<void> intialize();

  //get current user
  AuthUser? get currentUser;

  //login
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  //create a new user
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  //verify emails
  Future<void> verifyUserEmail();

  //logOut
  Future<void> logOut();
}
