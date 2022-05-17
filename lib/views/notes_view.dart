import 'package:flutter/material.dart';
import 'package:mynotes/components/named_navigator.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/services/auth/auth_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.login:
                  final shouldLogout = await showLogoutDialogBar(context);
                  if (shouldLogout == true) {
                    await AuthService.firebase().logOut();
                    namedNavigator(route: loginRoute, context: context);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(value: MenuAction.login, child: Text('logout'))
              ];
            },
          )
        ],
        // actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
      ),
      body: const Center(
        child: Text('Add a new note'),
      ),
    );
  }
}

//create a function to show dialogs
Future<bool> showLogoutDialogBar(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Sign out'),
      content: const Text('Are you sure you want to sign out?'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('cancel')),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Sign out'))
      ],
    ),
  ).then((value) => value ?? false);
}
