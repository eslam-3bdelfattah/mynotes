import 'package:flutter/material.dart';
import 'package:mynotes/views/login_views.dart';
import '../main.dart';
import '../views/register_view.dart';

//here we will put all our routes to clean the main
//create the map four the routes then put all routes in it
const loginRoute = 'login';
const registerRoute = 'register';
const notesRoute = 'notes';
Map<String, Widget Function(BuildContext context)> routes = {
  loginRoute: (context) => const LoginView(),
  registerRoute: (context) => const RegisterView(),
  notesRoute: (context) => const NotesView(),
};
