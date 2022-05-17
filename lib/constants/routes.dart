import 'package:flutter/material.dart';
import 'package:mynotes/views/login_views.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/verify_email.dart';
import '../views/register_view.dart';

//here we will put all our routes to clean the main
//create the map four the routes then put all routes in it
const loginRoute = 'login';
const registerRoute = 'register';
const verifyRoute = 'verify';
const notesRoute = 'notes';
Map<String, Widget Function(BuildContext context)> routes = {
  loginRoute: (context) => const LoginView(),
  registerRoute: (context) => const RegisterView(),
  verifyRoute: (context) => const VerifyEmailView(),
  notesRoute: (context) => const NotesView(),
};
