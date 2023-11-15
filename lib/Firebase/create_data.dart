import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../Components/alertDialog_widget.dart';

class RegisterService{
  final dbRef = FirebaseDatabase.instance.ref().child('User');
  bool isEmailValid(String email) {
    const pattern =
        r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  void createData(context, String username, String email, String password){
    var newChildRef = dbRef.push();
    var uniqueKey = newChildRef.key;

    try{
      if(dbRef.child(username.toString()) == username){
        showDialog(
            context: context,
            builder: (BuildContext context){
              return const AlertDialogWidget(
                  title: 'Sorry!',
                  content: 'Username has been taken by others.\nPlease try again!'
              );
            });
      }
      else{
        dbRef.child(username.toString()).set({
          'Username' : username,
          'Email' : email,
          'Password' : password,
          'userImage' : 'Default.png'
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialogWidget(
              title: 'You did it',
              content: ('You can login now'),

            );
          },
        );
      }
    }catch(e){
      // print(e);
    }
    // print('Generated unique key: $uniqueKey');
    // print(newChildRef.key);

  }
}