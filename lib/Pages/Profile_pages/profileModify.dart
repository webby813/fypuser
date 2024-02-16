import 'package:fypuser/Components/alertDialog_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Color/color.dart';
import '../../Components/avatar_widget.dart';
import '../../Components/title_widget.dart';
import '../../Components/container_widget.dart';
import '../../Components/divider_widget.dart';

class ProfileModify extends StatefulWidget {
  const ProfileModify({Key? key}) : super(key: key);

  @override
  State<ProfileModify> createState() => _ProfileModifyState();
}

class _ProfileModifyState extends State<ProfileModify> {
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


  void fetchUserinfo() async{
    DatabaseReference database = FirebaseDatabase.instance.ref();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userShared = prefs.getString('username') ?? '';
    database.child('User').child('$userShared/Username').onValue.listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        // print(userShared);
        usernameInfo = snapshot.value as String;
      });
    }, onError: (error){
    });
    database.child('User').child('$userShared/Email').onValue.listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        // print(UserEmailShared);
        useremailInfo = snapshot.value as String;
      });
    }, onError: (error){
    });
  }

  Future<void> loadImageFromDatabase() async {
    DatabaseReference database = FirebaseDatabase.instance.ref();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userShared = prefs.getString('username') ?? '';
    database.child('User').child('$userShared/userImage').onValue.listen((event) {
      var snapshot = event.snapshot;
      setState(() {
        userImagePath = snapshot.value as String;
      });
      if (userImagePath.isNotEmpty && userImagePath.isNotEmpty) {
        // Check if userImagePath is not null or empty before calling getDownloadURL().
        final storageRef = FirebaseStorage.instance.ref().child('User/$userImagePath');
        storageRef.getDownloadURL().then((imageUrl) {
          setState(() {
            this.imageUrl = imageUrl;
          });
        }).catchError((error) {
          // print("Error loading image: $error");
          setState(() {
            imageUrl = '';
          });
        });
      } else {
        setState(() {
          imageUrl = '';
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
          title: BarTitle.AppBarText('My Profile'),
          iconTheme: const IconThemeData(
            color: CustomColors.primaryColor,
          ),
        ),
        body: ListView(
          children: [
            if (imageUrl != null && imageUrl!.isNotEmpty)
              Center(
                child: AvatarWidgetEdit(
                    userimage: '$imageUrl',
                    username: usernameInfo
                  ),
                )
            else // Conditionally render AvatarWidget
            const Center(
              child: AvatarWidget(
                ),
              ),

            const Padding(padding: EdgeInsets.all(20)),
            const DivideWidget(),///Divide Line
            EditDrawer(
                title: usernameInfo,
                icon: Icons.person, onPress: (){}
            ),

            const DivideWidget(),///Divide Line
            EditDrawer(
                title: useremailInfo,
                icon: Icons.mail,
                onPress: (){
                  showDialog(context: context, builder: (BuildContext context){
                    return AlertToChangeDialog(
                      userid: usernameInfo,
                      title: 'Change email',
                      content: 'Enter your new email',
                      backText: 'Back',
                      confirmText: 'Yes',
                      type: 'Email',);
                  });
                }
            ),

            const DivideWidget(),///Divide Line
            EditDrawer(
                title: "Change password",
                icon: Icons.lock,
                onPress: (){
                  showDialog(context: context, builder: (BuildContext context){
                    return AlertToChangeDialog(
                        userid: usernameInfo,
                        title: 'Change password',
                        content: 'Enter your new password',
                        backText: 'Back',
                        confirmText: 'Yes',
                        type: 'Password');
                  });
                }
            ),
            const DivideWidget(),///Divide Line
          ],
        ),
      );
  }
}
