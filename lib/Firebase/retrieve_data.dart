import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fypuser/home.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../Components/alertDialog_widget.dart';
import '../SharedPref/user_pref.dart';

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
