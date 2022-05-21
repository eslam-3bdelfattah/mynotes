import 'package:flutter/material.dart';
import 'package:mynotes/components/named_navigator.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  String get userEmail => AuthService.firebase().currentUser!.email!;
  late final NotesService notesService;
  @override
  void initState() {
    notesService = NotesService();
    notesService.createDatabase();
    super.initState();
  }

  @override
  void dispose() {
    notesService.closeDb();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
              onPressed: () {
                // namedNavigator(route: newNoteRoute, context: context);
                Navigator.of(context).pushNamed(newNoteRoute);
              },
              icon: const Icon(Icons.add)),
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
          ),
        ],
        // actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
      ),
      body: FutureBuilder(
          future: notesService.createOrGetUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                  stream: notesService.AllNotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Text('all notes appear here..');

                      default:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                    }
                  },
                );
              default:
                return const CircularProgressIndicator();
            }
          }),
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
