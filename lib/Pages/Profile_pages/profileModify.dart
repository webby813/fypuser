import 'package:fypuser/Components/alertDialog_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Color/color.dart';
import '../../Components/avatar_widget.dart';
import '../../Components/barTitle_widget.dart';
import '../../Components/container_widget.dart';
import '../../Components/divider_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String usernameInfo = '';
  String useremailInfo = '';
  String userImagePath = '';
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();


  String? imageUrl;

  @override
  void initState(){
    super.initState();
    fetchUserinfo();
    loadImageFromDatabase();
  }

  @override
  void fetchUserinfo() async{
    DatabaseReference _database = FirebaseDatabase.instance.ref();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final UserShared = prefs.getString('username') ?? '';
    _database.child('User').child('$UserShared/Username').onValue.listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        // print(UserShared);
        usernameInfo = snapshot.value as String;
      });
    }, onError: (error){
    });
    _database.child('User').child('$UserShared/Email').onValue.listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        // print(UserEmailShared);
        useremailInfo = snapshot.value as String;
      });
    }, onError: (error){
    });
  }

  @override

  Future<void> loadImageFromDatabase() async {
    DatabaseReference _database = FirebaseDatabase.instance.ref();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final UserShared = prefs.getString('username') ?? '';
    _database.child('User').child('$UserShared/userImage').onValue.listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        userImagePath = snapshot.value as String;
      });
      if (userImagePath != null && userImagePath.isNotEmpty) {
        // Check if userImagePath is not null or empty before calling getDownloadURL().
        final storageRef = FirebaseStorage.instance.ref().child('User/$userImagePath');
        storageRef.getDownloadURL().then((imageUrl) {
          setState(() {
            this.imageUrl = imageUrl;
          });
        }).catchError((error) {
          print("Error loading image: $error");
          setState(() {
            this.imageUrl = '';
          });
        });
      } else {
        setState(() {
          this.imageUrl = '';
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors.defaultWhite,
          elevation: 0,
          title: BarTitle.AppBarText('My Profile'),
          iconTheme: const IconThemeData(
            color: CustomColors.primaryColor,
          ),
        ),
        body: ListView(
          children: [
            Center(
              child: AvatarWidgetEdit(
                  userimage: '$imageUrl',
                  username: '$usernameInfo'
              ),
            ),

            const Padding(padding: EdgeInsets.all(20)),
            DivideWidget(),///Divide Line
            EditDrawer(
                title: '$usernameInfo',
                icon: Icons.person, onPress: (){}
            ),

            DivideWidget(),///Divide Line
            EditDrawer(
                title: "$useremailInfo",
                icon: Icons.mail,
                onPress: (){
                  showDialog(context: context, builder: (BuildContext context){
                    return AlertToChangeDialog(
                      userid: '$usernameInfo',
                      title: 'Change email',
                      content: 'Enter your new email',
                      backText: 'Back',
                      confirmText: 'Yes',
                      type: 'Email',);
                  });
                }
            ),

            DivideWidget(),///Divide Line
            EditDrawer(
                title: "Change password",
                icon: Icons.lock,
                onPress: (){
                  showDialog(context: context, builder: (BuildContext context){
                    return AlertToChangeDialog(
                        userid: '$usernameInfo',
                        title: 'Change password',
                        content: 'Enter your new password',
                        backText: 'Back',
                        confirmText: 'Yes',
                        type: 'Password');
                  });
                }
            ),
            DivideWidget(),///Divide Line
          ],
        ),
      );
  }
}
