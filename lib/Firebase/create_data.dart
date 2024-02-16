import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class AddItem {
  Future<void> addToCart(context, String itemName, double price, int qty) async {
    String itemNameFromdb = '';
    String itemImageFromdb = '';
    double itemPriceFromdb = 0.0;

    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    String? username = sharedPref.getString('username');

    final DatabaseReference ref = FirebaseDatabase.instance.ref().child('User/$username/Cart/$itemName');
    final DatabaseReference listemItemName = FirebaseDatabase.instance.ref().child('Item/$itemName/Itemname');
    final DatabaseReference listenItemImage = FirebaseDatabase.instance.ref().child('Item/$itemName/itemImage');
    final DatabaseReference listenItemPrice = FirebaseDatabase.instance.ref().child('Item/$itemName/price');

    List<Future<void>> futures = [];
    try{
      futures.add(listemItemName.onValue.first.then((event) {
        var snapshot = event.snapshot;
        itemNameFromdb = snapshot.value as String;
        // print(itemNameFromdb);
      }));

      futures.add(listenItemImage.onValue.first.then((event) {
        var snapshot = event.snapshot;
        itemImageFromdb = snapshot.value as String;
        // print(itemImageFromdb);
      }));

      futures.add(listenItemPrice.onValue.first.then((event) {
        var snapshot = event.snapshot;
        itemPriceFromdb = snapshot.value as double;
        // print(itemPriceFromdb);
      }));
      // Wait for all the listeners to complete before updating the cart
      await Future.wait(futures);
      ref.update(
        {
          'itemImage': itemImageFromdb,
          'itemName': itemNameFromdb,
          'price': itemPriceFromdb,
          'qty': qty,
          'total': price * qty,
        },
      );
      SuccessDialog.show(context);
    }catch(e){
      FailureDialog.show(context);
      // print(e);
    }
  }
}