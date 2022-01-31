import 'package:flutter/material.dart';

Future<void> alert(BuildContext context,String info) async {
 await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(info),
          content: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('ok'),
          ),
        );
      });
}