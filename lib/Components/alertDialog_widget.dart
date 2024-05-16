import 'package:fypuser/Color/color.dart';
import 'package:fypuser/Firebase/update_data.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class AlertDialogWidget extends StatelessWidget {

  const AlertDialogWidget({super.key, required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class AlertToChangeDialog extends StatelessWidget {

  AlertToChangeDialog({super.key, required this.title, required this.content, required this.userid, required this.type, required this.backText, required this.confirmText});


  final String title;
  final String content;

  final String type;
  final String userid;
  final TextEditingController newData = TextEditingController();

  final String backText;
  final String confirmText;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(title),
      content: Text(content),
      actions: [
        TextField(
          controller: newData,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
            )
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Padding(padding: EdgeInsets.all(0)),
            TextButton(
              child: Text(backText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            const Padding(padding: EdgeInsets.all(0)),
            TextButton(
              child: Text(confirmText),
              onPressed: () {
                UpdateUser().updateUserInfo(userid, type, newData.text);
              },
            ),
          ],
        )
      ],
    );
  }
}

class SuccessDialog extends StatefulWidget {
  final String text;

  // Updated constructor to properly call the superclass constructor
  const SuccessDialog({Key? key, required this.text}) : super(key: key);

  @override
  _SuccessDialogState createState() => _SuccessDialogState();

  static void show(BuildContext context, String text) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => SuccessDialog(text: text),
    );
  }
}

class _SuccessDialogState extends State<SuccessDialog> {
  @override
  void initState() {
    super.initState();
    // Automatically dismiss the dialog after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Text(
          widget.text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400
        ),
      ), // Accessing widget.text to display the provided text
    );
  }
}


class FailureDialog {
  static void show(BuildContext context) async {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.white,
          content: Center(
            child: Text(
              'An error occurred, try again later',
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
    // Wait for 1 second before dismissing the dialog
    await Future.delayed(const Duration(seconds: 1));
    Navigator.of(context).pop();
  }
}






