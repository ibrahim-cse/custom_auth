import 'package:flutter/material.dart';

Future<void> logoutChoiceDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Are you sure you want to exit?',
            style: TextStyle(color: Colors.black),
          ),
          content: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    // Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => LoginForm(),
                    //     ),
                    //     (Route<dynamic> route) => false);
                  },
                ),
                const Padding(padding: EdgeInsets.all(16.0)),
                GestureDetector(
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.green),
                  ),
                  onTap: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            ),
          ),
        );
      });
}
