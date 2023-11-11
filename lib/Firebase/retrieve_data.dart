import 'package:fypuser/Components/alertDialog_widget.dart';
import 'package:fypuser/home.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../SharedPref/user_pref.dart';

class Identify{
  final dbRef = FirebaseDatabase.instance.reference().child('User');

  List dataList = [];
  List dataKeyList = [];

  Future<void> Login(context, String username, String password) async{
    dbRef.onValue.listen((event) {
      for(final child in event.snapshot.children){
        Map<dynamic,dynamic> obj = child.value as Map<dynamic, dynamic>;
        dataList.add(obj);
        dataKeyList.add(obj);
        for(var i=0; i!= dataList.length;i++){
        }

        try{
          for(var i=0; i!= dataList.length;i++){
            if(username != dataList[i]["Username"] || password != dataList[i]['Password']){
              print('Unsuccessful');
            }
            else if(username == dataList[i]['Username'] && password == dataList[i]['Password']){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Home()));
              SetSharedPref(username, password);
              saveLoggedInFlag();
              ///implement shared preferences here
              dataKeyList.clear();
              dataList.clear();
              print("Successful");
              break;
            }
            else{
              break;
            }
          }
        }catch(error){
          print(error);
        }
      }
    }
    );
  }

  Future<void> saveLoggedInFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }
}

class Listen {
  Future<void> listenData() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    String? value = sharedPref.getString('username');
    final dbRef = FirebaseDatabase.instance.reference().child('User/$value');

    dbRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      var data = snapshot.value.toString() as Map<dynamic, dynamic>?;
    }
    );
  }
}
