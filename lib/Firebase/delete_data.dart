import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteData{
  Future<void> removeCartItem(String itemName)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString("email");
    final dbRef = FirebaseFirestore.instance;

    final userCartItemSnapshot = await dbRef
        .collection('users')
        .doc(userEmail.toString())
        .collection('cart')
        .where('item_name', isEqualTo: itemName)
        .get();

    final userCartItemDoc = userCartItemSnapshot.docs.first;
    await userCartItemDoc.reference.delete();
  }
}