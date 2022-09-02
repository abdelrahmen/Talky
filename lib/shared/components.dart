import 'package:flutter/material.dart';

void navigateTo(context, widget) =>
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => widget,
    ));

void navigateWithNoBack(context, widget) =>
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => widget),
      (route) => false,
    );

void showSnackBar(context, message) {
  final snackBar = SnackBar(
    content: Text(message.toString()),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Widget mySeparator() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        height: 1,
        color: Colors.grey[200],
      ),
    );
