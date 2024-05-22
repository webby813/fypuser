import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fypuser/home.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../Components/alertDialog_widget.dart';
import '../SharedPref/user_pref.dart';

class RetrieveData {
  String generateUniqueId() {
    DateTime now = DateTime.now();
    return '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
  }

  Future<List<String>> retrieveCategories() async {
    try {
      final collRef = FirebaseFirestore.instance.collection('items');
      final snapshot = await collRef.get();
      final categories = snapshot.docs.map((doc) => doc.id).toList();
      return categories;
    } catch (e) {
      print('Error retrieving categories: $e');
      return [];
    }
  }

  Future<double> retrievePriceQty(String userEmail) async {
    try {
      var grandTotal = 0.0;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('cart')
          .get();

      for (var doc in querySnapshot.docs) {
        var itemPrice = double.parse(doc['price']);
        var quantity = doc['quantity'];

        grandTotal += itemPrice * quantity;
      }

      return grandTotal;
    } catch (e) {
      // print('Error retrieving price and quantity: $e');
      throw e;
    }
  }

  Stream<double> getWalletBalance() async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString("email");
    final dbRef = FirebaseFirestore.instance;

    yield* dbRef
        .collection('users')
        .doc(userEmail)
        .snapshots()
        .map((snapshot) => (snapshot['wallet_balance'] ?? 0).toDouble());
  }
}

class Checking{
  void checkCredential(context, String email, String password)async{
    final db = FirebaseFirestore.instance;

    Future<void> saveLoggedInFlag() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
    }

    try{
      QuerySnapshot snapshot = await db.collection('users').where('email', isEqualTo: email).where('password', isEqualTo: password).get();
      if(snapshot.docs.isNotEmpty){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Home()));
        setSharedPref(email, password);
        saveLoggedInFlag();
      }
      else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialogWidget(
              title: 'Error',
              content: 'Please ensure correct login credential',
            );
          },
        );
      }
    }catch(e){
      // print(e);
    }
  }
}

class Listen {
  Future<void> listenData() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    String? value = sharedPref.getString('username');
    final dbRef = FirebaseDatabase.instance.ref().child('User/$value');

    dbRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      var data = snapshot.value.toString() as Map<dynamic, dynamic>?;
    }
    );
  }
}
