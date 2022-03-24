import 'package:flutter/material.dart';

Future<void> showLoading(title, message, context) {
  return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('$title'),
          content: const SingleChildScrollView(
            child: Center(child: LinearProgressIndicator()),
          ),
        );
      });
}

Future<void> showMessage(title, message, context, {customOnClick}) {
  return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('$title'),
          content: Text("$message"),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                if (customOnClick == null) {
                  Navigator.of(context).pop();
                } else {
                  customOnClick();
                }
              },
            ),
          ],
        );
      });
}

Future<void> betterShowMessage(
    {required context,
    required String title,
    required Widget content,
    List<Widget>? buttons,
    Function()? onDefaultOK}) {
  buttons ??= [
    TextButton(
        onPressed: onDefaultOK ??
            () {
              Navigator.pop(context);
            },
        child: const Text('OK')),
  ];

  return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: content,
          actions: buttons,
        );
      });
}
