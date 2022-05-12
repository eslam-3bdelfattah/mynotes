import 'package:flutter/material.dart';

//create a function to hanle errors on login fails
//here we use future because showDialog is of type future<generic> and generic means that you are free to define the type
Future<void> showErrorDialog({
  required BuildContext context,
  required String errorText,
}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong'),
          content: Text(errorText),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
            )
          ],
        );
      });
}
