import 'package:flutter/material.dart';

//the Navigartor component
Future<dynamic> namedNavigator({
  required String route,
  required BuildContext context,
}) {
  return Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
}
