import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Components/alertDialog_widget.dart';

class Service{
  bool isEmailValid(String email) {
    const pattern =
        r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  void register(context, String username, String email, String password) async {
    final db = FirebaseFirestore.instance.collection("users");
    final data = {
      "name": username,
      "email": email,
      "password": password,
      "user_picture": "Default.png",
      "wallet_balance": 0
    };

    try {
      QuerySnapshot snapshot = await db.where("email", isEqualTo: email).get();

      if (snapshot.docs.isNotEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialogWidget(
              title: 'Sorry!',
              content: 'Email has been taken by others.\nPlease try again!',
            );
          },
        );
      } else {
        await db.doc(email).set(data);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialogWidget(
              title: 'You did it',
              content: 'You can login now',
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialogWidget(
            title: 'An error occur',
            content: 'Try again later$e',
          );
        },
      );
    }
  }
}

class UserDo {
  Future<void> isItemExist(BuildContext context, String selectedCategory, String itemName, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString("email");
    final dbRef = FirebaseFirestore.instance;

    final userCartItemSnapshot = await dbRef
        .collection('users')
        .doc(userEmail.toString())
        .collection('cart')
        .where('item_name', isEqualTo: itemName)
        .get();

    if (userCartItemSnapshot.docs.isNotEmpty) {
      final userCartItemDoc = userCartItemSnapshot.docs.first;
      int currentQuantity = userCartItemDoc['quantity'] ?? 0;
      await userCartItemDoc.reference.update({'quantity': currentQuantity + quantity});
    } else {
      addToCart(context, selectedCategory, itemName, quantity);
    }
  }

  Future<void> addToCart(context, String selectedCategory, String itemName, int quantity) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userEmail = prefs.getString("email");

      final dbRef = FirebaseFirestore.instance;
      DocumentSnapshot itemSnapshot = await dbRef.collection('items').doc(selectedCategory).collection('content').doc(itemName).get();

      Map<String, dynamic> selectedItem = itemSnapshot.data() as Map<String, dynamic>;
      selectedItem['quantity'] = quantity;
      await dbRef.collection('users').doc(userEmail.toString()).collection('cart').doc(itemName).set(selectedItem);

    } catch (e) {
      // print(e);
    }
  }
}