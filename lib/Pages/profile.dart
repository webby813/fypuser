import 'package:fypuser/Components/avatar_widget.dart';
import 'package:fypuser/Components/button_widget.dart';
import 'package:fypuser/Components/container_widget.dart';
import 'package:fypuser/Firebase/retrieve_data.dart';
import 'package:fypuser/Pages/Profile_pages/order.dart';
import 'package:fypuser/Pages/Profile_pages/profileModify.dart';
import 'package:fypuser/login.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fypuser/Color/color.dart';
import 'package:fypuser/Components/barTitle_widget.dart';
import 'package:fypuser/Components/divider_widget.dart';
import 'package:fypuser/Pages/Profile_pages/wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String usernameInfo = '';
  String useremailInfo = '';
  String userImagePath = '';

  String? imageUrl;

  void initState(){
    super.initState();
    fetchUserinfo();
    loadImageFromDatabase();
  }

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.defaultWhite,
        elevation: 0,
        title: BarTitle.AppBarText('Account'),
      ),

      body: ListView(
        children: [
          Center(
            child: AvatarWidgetEdit(
                userimage: '$imageUrl',
                username: '$usernameInfo'
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 125, vertical: 20),
            child: ButtonWidget.buttonWidget('Edit Profile', (){
              Listen().listenData();
              Navigator.push(context, MaterialPageRoute(builder: (_) => UserProfile()));
            }),
          ),

          DivideWidget(),///Divide Line
          DrawerWidget(
              title: "Wallet",
              icon: Icons.wallet,
              onPress: (){
                Navigator.push(context, MaterialPageRoute(builder: (_) => WalletPage()));
              }
          ),

          DivideWidget(),///Divide Line
          DrawerWidget(
              title: "Order",
              icon: Icons.list_alt,
              onPress: (){
                Navigator.push(context, MaterialPageRoute(builder: (_) => History()));
              }
          ),

          DivideWidget(),///Divide Line
          DrawerWidget(
              title: "About author",
              icon: Icons.person,
              onPress: (){}
          ),

          DivideWidget(),///Divide Line
          const Padding(padding: EdgeInsets.all(55)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 20),
            child: SecondButtonWidget.buttonWidget('Log out', ()async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear(); // Clear shared preferences
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => Login()),
                    (
                    Route<dynamic> route) => false, // Remove all existing routes from the stack
              );
            }),
          ),
        ],
      )
    );
  }
}


