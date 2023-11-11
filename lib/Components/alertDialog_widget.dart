import 'package:fypuser/Color/color.dart';
import 'package:fypuser/Firebase/update_data.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class AlertDialogWidget extends StatelessWidget {

  AlertDialogWidget({required this.Title, required this.content});

  final String Title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(Title),
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

  AlertToChangeDialog({required this.title, required this.content, required this.userid, required this.type, required this.backText, required this.confirmText});


  final String title;
  final String content;

  final String type;
  final String userid;
  final TextEditingController newData = TextEditingController();

  final backText;
  final confirmText;
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
                updateUser().updateUserInfo(userid, type, newData.text);
                print(newData.text);
              },
            ),
          ],
        )
      ],
    );
  }
}

class SuccessDialog extends StatefulWidget {
  @override
  _SuccessDialogState createState() => _SuccessDialogState();

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => SuccessDialog(),
    );
  }
}

class _SuccessDialogState extends State<SuccessDialog> {
  @override
  void initState() {
    super.initState();
    // Automatically dismiss the dialog after 1 second
    Future.delayed(Duration(seconds: 1), () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CustomColors.defaultWhite,
      content: Text('Add to cart successful'),
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
          backgroundColor: CustomColors.defaultWhite,
          content: Text('An error occur, try again later'),
        );
      },
    );
    // Wait for 1 second before dismissing the dialog
    await Future.delayed(
        Duration(seconds: 1));
    Navigator.of(context).pop();
  }
}






