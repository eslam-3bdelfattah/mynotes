import 'package:flutter/material.dart';

class NewNotesView extends StatelessWidget {
  const NewNotesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new note'),
      ),
      body: const Text('new notes add here'),
    );
  }
}
